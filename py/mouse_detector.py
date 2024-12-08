from pynput.mouse import Listener

# 定义鼠标按键事件回调函数
def on_click(x, y, button, pressed):
    if pressed:
        if button.name == 'left':
            print("Left button pressed at ({}, {})".format(x, y))  # 打印左键按下的位置
        elif button.name == 'right':
            print("Right button pressed at ({}, {})".format(x, y))  # 打印右键按下的位置

# 启动鼠标监听器
with Listener(on_click=on_click) as listener:
    listener.join()
