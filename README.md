# FPGA-PS2-VGA-Terminal
A hardware-based PS/2 keyboard to VGA monitor terminal implemented on Altera Cyclone IV.
# FPGA PS/2 to VGA Terminal 🖥️⌨️

A self-taught hardware engineering project that implements a complete digital system linking a standard PS/2 keyboard to a VGA monitor, built entirely from scratch in Verilog. 

## 📌 Project Overview
This project demonstrates a full data path from asynchronous input to video generation. It decodes PS/2 keyboard scan codes, processes them using a custom hardware state machine, stores the text in a RAM buffer, and outputs the result to a VGA display in real-time.

## 🛠️ Hardware & Tech Stack
* **Board:** Altera Cyclone IV (EP4CE6)
* **Language:** Verilog
* **Synthesis & Tools:** Intel Quartus Prime, Questa
* **Interfaces:** PS/2 Protocol, VGA Display Standard

## 🧠 Core Engineering Challenges Solved
* **Clock Domain Crossing:** Handled the synchronization between the extremely slow mechanical PS/2 clock (~10kHz) and the fast 50MHz FPGA system clock using Edge Detectors and memory buffers.
* **Debouncing & Noise Filtering:** Designed a digital filter to clean physical glitches from the keyboard lines.
* **Protocol Handling:** Implemented logic to ignore PS/2 'Break Codes' (e.g., `0xF0`) to prevent duplicate typing on key release.
* **Custom ROM:** Built a custom Font ROM module to translate ASCII values into pixel-by-pixel character display.

## 🎥 Demo
*(Note: Upload your video here or add a link to the LinkedIn post)*

## 🚀 Future Improvements
* Add a physical Backspace functionality.
* Add an automatic "Clear Screen" state machine.
