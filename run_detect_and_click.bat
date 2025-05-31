@echo off
setlocal
set "script_path=E:\gm_ai\yolo-opencv-detector-main\yolo-opencv-detector-main\4_yolo_opencv_detector.py"
powershell -Command "Start-Process python -ArgumentList '%script_path%' -Verb RunAs"
