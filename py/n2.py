import sys
from PySide6.QtCore import QTimer, Qt
from PySide6.QtGui import QColor, QPainter
from PySide6.QtWidgets import QApplication, QVBoxLayout, QWidget, QFrame, QHBoxLayout, QLabel
import serial

from PySide6.QtCore import QRectF
from PySide6.QtGui import QLinearGradient, QPen, QBrush, QRadialGradient

class LightIndicator(QWidget):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.setFixedSize(30, 30)
        self.is_on = False

    def paintEvent(self, event):
        painter = QPainter(self)
        painter.setRenderHint(QPainter.RenderHint.Antialiasing)

        # 创建径向渐变
        gradient = QRadialGradient(15, 15, 15)
        
        if self.is_on:
            # 亮起状态的渐变色
            gradient.setColorAt(0, QColor(255, 255, 200))  # 中心点最亮
            gradient.setColorAt(0.5, QColor(255, 215, 0))  # 金黄色
            gradient.setColorAt(1, QColor(218, 165, 32))   # 边缘暗金色
            
            # 添加光晕效果
            painter.setPen(Qt.PenStyle.NoPen)
            glow = QRadialGradient(15, 15, 20)
            glow.setColorAt(0, QColor(255, 215, 0, 100))
            glow.setColorAt(1, QColor(255, 215, 0, 0))
            painter.setBrush(glow)
            painter.drawEllipse(0, 0, 30, 30)
        else:
            # 关闭状态的渐变色
            gradient.setColorAt(0, QColor(180, 180, 180))
            gradient.setColorAt(0.5, QColor(140, 140, 140))
            gradient.setColorAt(1, QColor(100, 100, 100))

        # 绘制主体
        painter.setPen(Qt.PenStyle.NoPen)
        painter.setBrush(gradient)
        painter.drawEllipse(2, 2, 26, 26)

        # 只在亮起状态添加高光效果
        if self.is_on:
            highlight = QLinearGradient(5, 5, 15, 15)
            highlight.setColorAt(0, QColor(255, 255, 255, 120))
            highlight.setColorAt(1, QColor(255, 255, 255, 0))
            painter.setBrush(highlight)
            painter.drawEllipse(5, 5, 10, 10)

    def setStatus(self, status):
        self.is_on = status
        self.update()
        
class StyleFrame(QFrame):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.setFrameStyle(QFrame.Shape.Box | QFrame.Shadow.Raised)
        self.setLineWidth(2)
        self.setStyleSheet("""
            StyleFrame {
                background-color: #ffffff;
                border-radius: 15px;
                border: 2px solid #e0e0e0;
                padding: 10px;
            }
        """)

class Ui_Form(object):
    def __init__(self):
        super().__init__()
    
    def setupUi(self, Form):
        if not Form.objectName():
            Form.setObjectName(u"Form")
        Form.setEnabled(True)
        Form.resize(500, 400)
        Form.setMinimumSize(500, 400)
        Form.setStyleSheet("""
            QWidget {
                background-color: #f8f9fa;
                font-family: 'Segoe UI', Arial;
            }
            QLabel {
                color: #212529;
            }
        """)

        # 主布局
        self.main_layout = QVBoxLayout(Form)
        self.main_layout.setSpacing(20)
        self.main_layout.setContentsMargins(25, 25, 25, 25)

        self.state_dict = {
            0b000: "关闭状态",
            0b001: "待机状态",
            0b010: "请选择模式",
            0b011: "风力一级",
            0b100: "风力二级",
            0b101: "风力三级",
            0b110: "自清洁",
            0b111: "等待返回待机状态"
        }

        # 状态面板
        self.status_frame = StyleFrame()
        self.status_layout = QVBoxLayout(self.status_frame)
        self.status_layout.setSpacing(20)

        # 时间显示部分
        self.time_widget = QWidget()
        self.time_layout = QHBoxLayout(self.time_widget)
        self.time_layout.setSpacing(15)

        # 当前时间
        self.current_time_container = QWidget()
        self.current_time_layout = QVBoxLayout(self.current_time_container)
        self.current_time_layout.setSpacing(8)
        self.current_time_Label = QLabel("当前时间")
        self.current_Time_Display_Label = QLabel("00:00:00")
        self.current_time_layout.addWidget(self.current_time_Label)
        self.current_time_layout.addWidget(self.current_Time_Display_Label)

        # 工作时间
        self.work_time_container = QWidget()
        self.work_time_layout = QVBoxLayout(self.work_time_container)
        self.work_time_layout.setSpacing(8)
        self.cur_Working_Time_Label = QLabel("工作时间")
        self.current_Work_Time_Display_Label = QLabel("00:00:00")
        self.work_time_layout.addWidget(self.cur_Working_Time_Label)
        self.work_time_layout.addWidget(self.current_Work_Time_Display_Label)

        # 倒计时
        self.countdown_container = QWidget()
        self.countdown_layout = QVBoxLayout(self.countdown_container)
        self.countdown_layout.setSpacing(8)
        self.Count_down_Label = QLabel("倒计时")
        self.current_Counting_Time_Display_Label = QLabel("00:00:00")
        self.countdown_layout.addWidget(self.Count_down_Label)
        self.countdown_layout.addWidget(self.current_Counting_Time_Display_Label)

        # 添加到时间布局
        self.time_layout.addWidget(self.current_time_container)
        self.time_layout.addWidget(self.work_time_container)
        self.time_layout.addWidget(self.countdown_container)

        # 状态显示
        self.status_container = QWidget()
        self.status_layout_h = QHBoxLayout(self.status_container)
        self.status_layout_h.setSpacing(15)
        self.Current_Mode_label = QLabel("当前模式")
        self.current_Mode_Display_Label = QLabel("待机状态")
        self.current_Mode_Display_Label.setFixedWidth(200)
        self.light_indicator = LightIndicator()

        self.status_layout_h.addWidget(self.Current_Mode_label)
        self.status_layout_h.addWidget(self.current_Mode_Display_Label)
        self.status_layout_h.addWidget(self.light_indicator)
        self.status_layout_h.addStretch()

        # 提醒标签
        self.reminder_label = QLabel("")
        self.reminder_label.setWordWrap(True)
        self.reminder_label.setStyleSheet("""
            QLabel {
                color: #721c24;
                font-weight: bold;
                padding: 10px;
                border-radius: 8px;
                background-color: #f8d7da;
                border: 1px solid #f5c6cb;
                margin: 5px;
            }
        """)
        self.reminder_label.hide()

        # 添加所有组件到主布局
        self.status_layout.addWidget(self.time_widget)
        self.status_layout.addWidget(self.status_container)
        self.status_layout.addWidget(self.reminder_label)

        self.main_layout.addWidget(self.status_frame)

        # 设置样式
        self.setup_styles()

        # 串口设置
        self.ser = serial.Serial('COM6', 9600)
        self.buffer = b""

        # 启动定时器
        self.timer = QTimer()
        self.timer.timeout.connect(self.update_display)
        self.timer.start(100)

    def setup_styles(self):
        time_label_style = """
            QLabel {
                font-size: 14px;
                font-weight: bold;
                color: #495057;
                margin-bottom: 5px;
            }
        """

        time_display_style = """
            QLabel {
                font-size: 18px;
                font-weight: bold;
                color: #0056b3;
                background-color: white;
                padding: 8px 12px;
                border-radius: 8px;
                border: 2px solid #e9ecef;
                min-width: 120px;
                text-align: center;
            }
        """

        mode_label_style = """
            QLabel {
                font-size: 16px;
                font-weight: bold;
                color: #495057;
            }
        """

        self.state_styles = {
			0b000: """
				QLabel {
					font-size: 14px;
					font-weight: bold;
					color: white;
					background-color: #6c757d;  /* 灰色 */
					padding: 5px 10px;
					border-radius: 5px;
					min-width: 80px;
                    max-height: 15px;
					text-align: center;
				}
			""",
			0b001: """
				QLabel {
					font-size: 14px;
					font-weight: bold;
					color: white;
					background-color: #17a2b8;  /* 青色 */
					padding: 5px 10px;
					border-radius: 5px;
					min-width: 80px;
                    max-height: 15px;
					text-align: center;
				}
			""",
			0b010: """
				QLabel {
					font-size: 14px;
					font-weight: bold;
					color: white;
					background-color: #ffc107;  /* 黄色 */
					padding: 5px 10px;
					border-radius: 5px;
					min-width: 80px;
                    max-height: 15px;
					text-align: center;
				}
			""",
			0b011: """
				QLabel {
					font-size: 14px;
					font-weight: bold;
					color: white;
					background-color: #28a745;  /* 绿色 */
					padding: 5px 10px;
					border-radius: 5px;
					min-width: 80px;
                    max-height: 15px;
					text-align: center;
				}
			""",
			0b100: """
				QLabel {
					font-size: 14px;
					font-weight: bold;
					color: white;
					background-color: #20c997;  /* 青绿色 */
					padding: 5px 10px;
					border-radius: 5px;
					min-width: 80px;
                    max-height: 15px;
					text-align: center;
				}
			""",
			0b101: """
				QLabel {
					font-size: 14px;
					font-weight: bold;
					color: white;
					background-color: #007bff;  /* 蓝色 */
					padding: 5px 10px;
					border-radius: 5px;
					min-width: 80px;
                    max-height: 15px;
					text-align: center;
				}
			""",
			0b110: """
				QLabel {
					font-size: 14px;
					font-weight: bold;
					color: white;
					background-color: #e83e8c;  /* 粉色 */
					padding: 5px 10px;
					border-radius: 5px;
					min-width: 80px;
                    max-height: 15px;
					text-align: center;
				}
			""",
			0b111: """
				QLabel {
					font-size: 14px;
					font-weight: bold;
					color: white;
					background-color: #fd7e14;  /* 橙色 */
					padding: 5px 10px;
					border-radius: 5px;
					min-width: 80px;
                    max-height: 15px;
                    text-align: center;
				}
			"""
		}

        # 应用样式
        self.current_time_Label.setStyleSheet(time_label_style)
        self.cur_Working_Time_Label.setStyleSheet(time_label_style)
        self.Count_down_Label.setStyleSheet(time_label_style)

        self.current_Time_Display_Label.setStyleSheet(time_display_style)
        self.current_Work_Time_Display_Label.setStyleSheet(time_display_style)
        self.current_Counting_Time_Display_Label.setStyleSheet(time_display_style)

        self.Current_Mode_label.setStyleSheet(mode_label_style)
        #self.current_Mode_Display_Label.setStyleSheet(mode_display_style)

    def update_display(self):
        if not self.ser.is_open:
            print("串口连接已断开，程序退出")
            sys.exit()

        if self.ser.in_waiting > 0:
            self.buffer += self.ser.read(self.ser.in_waiting)

        while len(self.buffer) >= 1 and self.buffer[0] != 0xFF:
            self.buffer = self.buffer[1:]

        while len(self.buffer) >= 15:
            data = self.buffer[1:15]
            self.buffer = self.buffer[15:]

            state = data[0]
            current_hour = data[1]
            current_min = data[2]
            current_sec = data[3]
            working_hour = data[4]
            working_min = data[5]
            working_sec = data[6]
            count_down_hour = data[7]
            count_down_min = data[8]
            count_down_sec = data[9]
            hour_threshold = data[10]
            min_threshold = data[11]
            sec_threshold = data[12]
            light_on = data[13]

            self.current_Time_Display_Label.setText(f"{current_hour:02}:{current_min:02}:{current_sec:02}")
            self.current_Work_Time_Display_Label.setText(f"{working_hour:02}:{working_min:02}:{working_sec:02}")
            state_str = self.state_dict.get(state, "未知状态")
            self.current_Mode_Display_Label.setStyleSheet(self.state_styles[state])
            self.current_Mode_Display_Label.setText(f"{state_str}")

            if state not in [0b101, 0b110, 0b111]:
                self.current_Counting_Time_Display_Label.hide()
                self.Count_down_Label.hide()
            else:
                self.current_Counting_Time_Display_Label.show()
                self.Count_down_Label.show()
                self.current_Counting_Time_Display_Label.setText(
                    f"{count_down_hour:02}:{count_down_min:02}:{count_down_sec:02}")

            self.light_indicator.setStatus(light_on)

            if (working_hour > hour_threshold) or ((working_hour == hour_threshold) and (working_min > min_threshold)) or ((working_hour == hour_threshold) and (working_min == min_threshold) and (working_sec > sec_threshold)):
                self.reminder_label.setText(f"提醒：连续运行已超过{hour_threshold}小时{min_threshold}分钟{sec_threshold}秒，建议手动清洁或进入自清洁模式")
                self.reminder_label.show()
            elif state == 0b110:
                self.reminder_label.setText("提醒：正在进行自清洁，请稍候")
                self.reminder_label.show()
            else:
                self.reminder_label.hide()

class MainWindow(QWidget, Ui_Form):
    def __init__(self):
        super().__init__()
        self.setupUi(self)

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = MainWindow()
    window.setWindowTitle("设备状态显示与控制")
    window.show()
    sys.exit(app.exec())