# 🏡 HomeLab Repository

Repo này được dùng để lưu trữ **thông tin cài đặt**, **file config**, **script tự động hóa** và **flow thiết kế** của hệ thống HomeLab cá nhân.

## 📂 Cấu trúc thư mục

homelab/
│── docs/                # Tài liệu, ghi chú, hướng dẫn cài đặt
│   ├── network.md
│   ├── proxmox_setup.md
│   └── docker_notes.md
│
│── configs/             # File config của dịch vụ, máy ảo, container
│   ├── nginx/
│   │   └── nginx.conf
│   ├── traefik/
│   └── proxmox/
│
│── flows/               # Lưu các sơ đồ, luồng hoạt động
│   ├── network_flow.drawio
│   └── vm_topology.png
│
│── scripts/             # Script tự động hóa (bash, ansible, terraform…)
│   ├── backup.sh
│   └── deploy_docker.sh
│
└── README.md            # Giới thiệu chung repo

## 📑 Nội dung

- **docs/**: Ghi chú chi tiết từng bước cài đặt (Proxmox, Docker, VM, Network…)
- **configs/**: Lưu file cấu hình (dùng làm tham khảo, tránh lưu mật khẩu/tokens)
- **flows/**: Lưu sơ đồ hệ thống (`.drawio`, `.png`)
- **scripts/**: Script bash/ansible/terraform để tự động hóa

## ⚠️ Lưu ý

- Không commit **password, API key, private key** trực tiếp vào repo  
- Dùng `.gitignore` cho file nhạy cảm  
- Nếu cần giữ config thật:  
  - Dùng `*.example` file (vd: `nginx.conf.example`)  
  - Hoặc dùng `.env` template  

## 🚀 Mục tiêu

- Ghi lại toàn bộ quá trình build HomeLab  
- Chuẩn hóa cấu hình để dễ triển khai lại từ đầu  
- Từng bước tự động hóa (IaC – Infrastructure as Code)  

## 📌 Ghi chú

- Repo này chỉ mang tính **tham khảo cá nhân**  
- Có thể mở rộng thêm Wiki hoặc GitHub Pages để dễ tra cứu  

---
✍️ *Maintainer: Quan LA*
