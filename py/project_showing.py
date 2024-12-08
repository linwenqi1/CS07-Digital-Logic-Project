import tkinter as tk
import serial

# 设置串口
serial_port = "COM6"  # 替换为你的串口（例如 COM1, COM2, COM3 等）
baud_rate = 9600
ser = serial.Serial(serial_port, baud_rate)

# 创建窗口
root = tk.Tk()
root.title("系统状态显示")

# 创建标签来显示当前时间、工作时间和状态
current_time_label = tk.Label(root, text="当前时间: 00:00:00", font=("Arial", 14))
current_time_label.pack(pady=10)

working_time_label = tk.Label(root, text="工作时间: 00:00:00", font=("Arial", 14))
working_time_label.pack(pady=10)

state_label = tk.Label(root, text="系统状态: 0", font=("Arial", 14))
state_label.pack(pady=10)

# 字节缓冲区
current_hour = current_min = current_sec = 0
working_hour = working_min = working_sec = 0
state = 0
buffer = b""  # 存储接收到的数据

state_dict = {
    0b000: "关闭状态",
    0b001: "待机状态",
    0b010: "请选择模式",
    0b011: "风力一级",
    0b100: "风力二级",
    0b101: "风力三级",
    0b110: "正在自清洁",
    0b111: "等待返回待机状态"
}

# 更新显示内容的函数
def update_display():
    global current_hour, current_min, current_sec, working_hour, working_min, working_sec, state, buffer

    # 检查串口缓存中是否有数据
    if ser.in_waiting > 0:
        # 读取串口数据并保存到缓冲区
        buffer += ser.read(ser.in_waiting)
    while len(buffer) >= 1 and buffer[0] != 0xFF:
        # 如果不是起始符，就丢掉第一个字节
        buffer = buffer[1:]
    # 每次处理缓冲区中的数据
    while len(buffer) >= 8:
        # 只处理完整的一组数据（7个字节）
        data = buffer[1:8]  # 获取前 7 个字节
        buffer = buffer[8:]  # 更新缓冲区，移除已处理的字节

        # 假设数据的顺序为：state, current_hour, current_min, current_sec, working_hour, working_min, working_sec
        state = data[0]  # 第一个字节是状态
        current_hour = data[1]  # 第二个字节是当前小时
        current_min = data[2]  # 第三个字节是当前分钟
        current_sec = data[3]  # 第四个字节是当前秒钟
        working_hour = data[4]  # 第五个字节是工作小时
        working_min = data[5]  # 第六个字节是工作分钟
        working_sec = data[6]  # 第七个字节是工作秒钟

        # 更新界面
        current_time_label.config(text=f"当前时间: {current_hour:02}:{current_min:02}:{current_sec:02}")
        working_time_label.config(text=f"工作时间: {working_hour:02}:{working_min:02}:{working_sec:02}")
        state_str = state_dict.get(state, "未知状态")  # 如果状态未定义，显示“未知状态”
        state_label.config(text=f"系统状态: {state_str}")

    # 继续更新，每 500 毫秒更新一次
    root.after(100, update_display)

# 启动更新
update_display()

# 启动 GUI
root.mainloop()
