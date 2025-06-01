
---

## Disclaimer / 聲明

This project is intended for **educational and learning purposes only**.  
All automation features are implemented solely to explore real-time object detection, model deployment, and system control integration in a safe, offline environment.

The game "Gersang" (巨商) is used purely as a technical testbed for computer vision application, without modifying game memory or interfering with network communication.

Please do not use this project or its derived components for any unethical behavior, including but not limited to:
- Online cheating
- Violation of game terms of service
- Unauthorized automation in multiplayer environments

---

本專案僅供**學術研究與個人學習使用**。  
本系統之自動化功能，僅用於探討即時影像辨識、深度學習模型部署與系統整合等技術流程，並未涉及任何記憶體操作或網路干擾。

《巨商》僅作為電腦視覺應用的測試平台，所有功能執行於本地端視窗擷取，不會對遊戲伺服器或其他玩家產生影響。

請勿將本專案或其延伸應用於以下行為：
- 線上作弊行為
- 違反遊戲使用條款
- 多人遊戲環境中的未經授權自動化操作


---


# YOLOv4-tiny Object Detection and Auto Combat System for Gersang

This project implements a real-time object detection and automation system for the PC game "Gersang" using YOLOv4-tiny, OpenCV, and keyboard/mouse input simulation.

The system detects in-game enemies (e.g., skeleton monsters), and automatically performs combat actions such as targeting, pressing keys, and attacking based on model predictions.

---

## 🎥 Demo Video

[![Watch the video](https://img.youtube.com/vi/k_GV45inPjE/0.jpg)](https://youtu.be/k_GV45inPjE)

---

## Features

- Real-time detection using a custom-trained YOLOv4-tiny model
- Game screen capture via Windows API (`win32gui`, `win32ui`)
- Auto control of mouse position and keyboard actions via `pynput`
- End-to-end pipeline from data collection to model deployment
- Fully offline execution on Windows (no game API injection required)

## Technologies Used

| Component | Description |
|----------|-------------|
| YOLOv4-tiny (Darknet) | Lightweight object detection model |
| OpenCV (cv2.dnn) | Model inference and image preprocessing |
| win32gui / win32ui | Capture specific game window content |
| pynput | Keyboard and mouse event simulation |
| Google Colab + AlexeyAB/darknet | Model training environment |
| makesense.ai | Image annotation tool (YOLO format) |

## Project Directory Overview

```
yoho_gm_test/
├── 1_generate_dataset.ipynb
├── 2_label_dataset.ipynb
├── 3_yolo_model_training.ipynb
├── 4_yolo_opencv_detector.ipynb
├── yolov4-tiny/
│   ├── yolov4-tiny-custom.cfg
│   ├── yolov4-tiny-custom_last.weights
│   ├── obj.names / obj.data
├── images/
├── obj/
├── requirements.txt
```

## Training Workflow

### 1. Image Collection
```python
WindowCapture("Gersang").generate_image_dataset()
```

### 2. Annotation

- Use https://makesense.ai to label in-game enemies
- Export labels in YOLO format
- Place `.txt` and `.jpg` files together

### 3. Configuration

- Use `2_label_dataset.ipynb` to generate `obj.names`, `obj.data`, and `yolov4-tiny-custom.cfg`

### 4. Model Training

Upload training data to Google Drive, then run the following command in Google Colab:
```bash
./darknet detector train data/obj.data cfg/yolov4-tiny-custom.cfg yolov4-tiny.conv.29 -dont_show
```

### 5. Export Trained Weights

After training completes in Google Colab, download the generated weights file:

```
yolov4-tiny-custom_last.weights
```

Place it in the following directory with your config file:

```
./yolov4-tiny/
├── yolov4-tiny-custom.cfg

# yolov4-tiny-custom_last.weights placement options:
# 1. Place it inside the yolov4-tiny folder (recommended for organization)
# 2. Place it in the project root directory (e.g., alongside your .py script)

./yolov4-tiny-custom_last.weights
```

Make sure your detection script is configured like this:

```python
cfg_file_name = "./yolov4-tiny/yolov4-tiny-custom.cfg"
weights_file_name = "yolov4-tiny-custom_last.weights"
window_name = "Gersang"
```

### 6. Detection Execution

Run `4_yolo_opencv_detector.ipynb` to begin detection and simulate input.

## Technical Notes

- The model input resolution is fixed at 416x416
- Detection outputs are scaled back to original game window size
- The game window must be in windowed mode and remain in the foreground

## Customization Summary

This implementation builds upon [moises-dias/yolo-opencv-detector](https://github.com/moises-dias/yolo-opencv-detector) with several task-specific adjustments to fit the game automation context.

Modifications include:

- Replacing static image logic with real-time window capture using Win32 API
- Adapting automation logic for keyboard and mouse control in Gersang
- Implementing a full pipeline for data collection, labeling, training, and deployment
- Automatically generating YOLO config files based on labeled classes
- Removing unrelated modules to focus solely on one use case

These adjustments aim to create a practical and reusable workflow for real-world CV-based automation.

## Credits

- YOLO + OpenCV base: [moises-dias/yolo-opencv-detector](https://github.com/moises-dias/yolo-opencv-detector)
- YOLOv4: [AlexeyAB/darknet](https://github.com/AlexeyAB/darknet)
- Annotation tool: https://makesense.ai
---

# YOLOv4-tiny 巨商遊戲自動打怪系統（中文說明）

本專案基於 YOLOv4-tiny 模型與 OpenCV，結合 Windows 原生 API 與滑鼠鍵盤模擬控制，針對 PC 遊戲《巨商》實作即時辨識與戰鬥自動化功能。

## 主要功能

- 使用 YOLOv4-tiny 模型進行遊戲畫面敵人即時辨識
- 擷取遊戲視窗內容（視窗模式下）
- 根據辨識結果自動移動滑鼠與按下攻擊鍵（例如 1、G、Space）
- 完整資料收集、標註、訓練與推論流程整合

## 使用技術

| 技術 | 說明 |
|------|------|
| YOLOv4-tiny | 輕量級深度學習目標偵測模型 |
| OpenCV (cv2.dnn) | 模型推論與圖像處理 |
| win32gui / win32ui | 擷取遊戲視窗畫面 |
| pynput | 模擬鍵盤滑鼠行為 |
| makesense.ai | 圖像標註平台（YOLO 格式） |
| Google Colab + AlexeyAB/darknet | 雲端訓練環境與框架 |

## 專案流程

1. 使用 `1_generate_dataset.ipynb` 擷取遊戲畫面圖片
2. 上傳至 makesense.ai 進行標註（例如：bow_skeleton、gun_skeleton）
3. 使用 `2_label_dataset.ipynb` 自動生成訓練設定檔（obj.names、obj.data、cfg）
4. 在 `3_yolo_model_training.ipynb` 中使用 Google Colab 執行訓練
5. 訓練完成後，下載 `yolov4-tiny-custom_last.weights`。將此檔案放置至 `./yolov4-tiny/`
   # yolov4-tiny-custom_last.weights 可選放置路徑：
    # 1. 放在 yolov4-tiny 資料夾內（建議，集中管理）
    # 2. 放在根目錄（例如：與 .py 程式碼同層）
7. 確保你的推論程式使用下列設定：

```python
cfg_file_name = "./yolov4-tiny/yolov4-tiny-custom.cfg"
weights_file_name = "yolov4-tiny-custom_last.weights"
window_name = "Gersang"
```

7. 執行 `4_yolo_opencv_detector.ipynb`，開始即時辨識與完全自動打怪操作

## 注意事項

- 模型輸入解析度為 416x416（YOLOv4-tiny 預設）
- 預測框會自動換算回原始視窗的座標空間
- 執行過程需保持《巨商》遊戲視窗在前景（視窗模式）
- 本專案不涉及記憶體讀取或修改遊戲本體，純屬視覺辨識與模擬控制

## 自訂說明

本專案原始參考自 [moises-dias/yolo-opencv-detector](https://github.com/moises-dias/yolo-opencv-detector)，並依實際應用進行下列調整：

- 將靜態圖示範重構為即時遊戲畫面擷取
- 加入適用於《巨商》的滑鼠與鍵盤自動控制邏輯
- 建立標註 → 訓練 → 推論完整流程，並能針對不同類別自動產生配置
- 刪除與應用無關的模擬器/fruit demo 模組，聚焦單一遊戲場景

這些調整旨在使電腦視覺模型更貼近實務，並實現遊戲中實際控制操作的自動化。
