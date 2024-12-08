from pynput.keyboard import Listener

# 定义键盘按键事件回调函数
def on_press(key):
    try:
        print(f'按下了字母：{key.char}')  # 如果是字母或数字
    except AttributeError:
        print(f'按下了特殊键：{key}')  # 如果是特殊按键（如Ctrl、Shift等）

def on_release(key):
    print(f'释放了键：{key}')
    # 你可以通过按特定的键来停止监听，例如按下Esc键退出
    if key == 'esc':
        return False  # 返回False会停止监听

# 启动键盘监听器
with Listener(on_press=on_press, on_release=on_release) as listener:
    listener.join()
