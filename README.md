```markdown
# 🧠 Biometric Attendance App (Flutter)

A **smart attendance system** built with Flutter that integrates **Bluetooth scanning**, **biometric fingerprint authentication**, and **role-based dashboards** for **Hosts** and **Clients**.  

This app allows:
- **Hosts (Teachers/Admins)** to manage class attendance via Bluetooth-connected devices.
- **Clients (Students)** to log attendance securely using fingerprint authentication.

---

## 🚀 Features

### 👨‍🏫 Host Features
- Login with username and password.
- Scan nearby Bluetooth devices.
- Allow device connections and discover available services.
- Navigate to Host Dashboard to view class attendance.
- Check attendance details for each class.

### 👩‍🎓 Client Features
- Login as a student.
- View available subjects.
- Use **fingerprint authentication** to mark attendance.
- Verify fingerprints against backend PHP API via HTTP.

### 🔐 Biometric Integration
- Secure fingerprint authentication using the [`local_auth`](https://pub.dev/packages/local_auth) Flutter package.

### 📶 Bluetooth Integration
- Discover and connect to Bluetooth devices using [`flutter_blue_plus`](https://pub.dev/packages/flutter_blue_plus).

### ⚙️ Backend Communication
- Sends fingerprint data for verification to a backend endpoint:  
  👉 **`http://192.168.1.100/verify-fingerprint.php`**

---

## 🧩 Tech Stack

| Component | Technology |
|------------|-------------|
| **Frontend** | Flutter (Dart) |
| **Bluetooth** | `flutter_blue_plus` |
| **Biometrics** | `local_auth` |
| **Permissions** | `permission_handler` |
| **HTTP Requests** | `http` |
| **Backend (Example)** | PHP + MySQL (for fingerprint verification) |

---

## 🧱 Project Structure

```

lib/
├── main.dart                # Entry point of the app
├── api_service.dart         # (Optional) API integration file
├── screens/
│   ├── login_screen.dart
│   ├── host_login_screen.dart
│   ├── client_login_screen.dart
│   ├── bluetooth_page.dart
│   ├── host_dashboard.dart
│   ├── client_dashboard.dart
│   ├── attendance_page.dart
│   ├── fingerprint_attendance_screen.dart
│   └── attendance_screen.dart

````

> 💡 You can refactor each screen into separate files as your app grows.

---

## ⚙️ Installation & Setup

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/NehanShaikh07/biometric-attendance-app.git
cd biometric-attendance-app
````

### 2️⃣ Install Dependencies

```bash
flutter pub get
```

### 3️⃣ Run the App

```bash
flutter run
```

### 4️⃣ Backend Configuration

Ensure your backend server is running locally and accessible at:

```
http://192.168.1.100/verify-fingerprint.php
```

Example API Response:

```json
{
  "exists": true
}
```

---

## 📱 Required Permissions

Make sure the following permissions are granted:

* Location Access (for Bluetooth scanning)
* Bluetooth Scan, Connect, and Advertise
* Biometric Authentication (Fingerprint/Face ID)

---

## 🧠 Workflow Overview

### 🔹 For Host:

1. Login as Host
2. Scan and connect to Bluetooth devices
3. Access Host Dashboard
4. View attendance records

### 🔹 For Client:

1. Login as Client
2. Select subject
3. Authenticate with fingerprint
4. Attendance logged and verified with backend

---

## 🛠 Dependencies Used

| Package                                                             | Purpose                           |
| ------------------------------------------------------------------- | --------------------------------- |
| [`flutter_blue_plus`](https://pub.dev/packages/flutter_blue_plus)   | Bluetooth scanning and connection |
| [`permission_handler`](https://pub.dev/packages/permission_handler) | Handle permissions                |
| [`local_auth`](https://pub.dev/packages/local_auth)                 | Fingerprint authentication        |
| [`http`](https://pub.dev/packages/http)                             | Backend API communication         |

---

## 💡 Future Enhancements

* 🔄 Sync attendance data in real-time with the database
* 🧾 Detailed analytics per student/subject
* 🕒 Face recognition hybrid attendance model
* 🔔 Notifications for attendance confirmation

---

## 👨‍💻 Author

**🧑‍💻 Nehan Shaikh**
🎓 B.E. Computer Science & Engineering (AI & ML)
📍 India
🔗 [GitHub Profile](https://github.com/NehanShaikh)
✉️ [Email me](mailto:nehanshaikh07@gmail.com)

---

## 🪪 License

This project is licensed under the **MIT License** — feel free to use and modify it for educational or professional purposes.

---

### ⭐ If you find this project helpful, please give it a star on GitHub!
