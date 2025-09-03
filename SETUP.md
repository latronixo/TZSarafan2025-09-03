# Инструкция по настройке проекта

## 1. Добавление зависимостей через Swift Package Manager

### В Xcode:
1. Откройте проект `TZSarafan2025-09-03.xcodeproj`
2. Выберите проект в навигаторе
3. Перейдите на вкладку "Package Dependencies"
4. Нажмите "+" для добавления новой зависимости

### Добавьте следующие пакеты:

#### Firebase iOS SDK
- **URL**: `https://github.com/firebase/firebase-ios-sdk`
- **Версия**: Latest
- **Выберите продукты**: 
  - `FirebaseAuth`
  - `FirebaseCore`

#### Google Sign-In iOS
- **URL**: `https://github.com/google/GoogleSignIn-iOS`
- **Версия**: Latest
- **Выберите продукты**: 
  - `GoogleSignIn`

## 2. Настройка Firebase

### Создание проекта Firebase:
1. Перейдите в [Firebase Console](https://console.firebase.google.com/)
2. Нажмите "Создать проект"
3. Введите название проекта (например, "TZSarafan2025")
4. Включите Google Analytics (опционально)
5. Выберите или создайте Google Analytics аккаунт

### Добавление iOS приложения:
1. В Firebase Console нажмите "Добавить приложение" → iOS
2. Введите Bundle ID: `com.potatoes.TZSarafan2025-09-03`
3. Введите название приложения: `TZSarafan2025-09-03`
4. Скачайте `GoogleService-Info.plist`
5. Замените файл `GoogleService-Info.plist` в проекте

### Настройка Authentication:
1. В Firebase Console перейдите в "Authentication" → "Sign-in method"
2. Включите следующие провайдеры:

#### Apple Sign-In:
1. Нажмите на "Apple"
2. Включите провайдер
3. Настройте Service ID (если необходимо)

#### Google Sign-In:
1. Нажмите на "Google"
2. Включите провайдер
3. Укажите email для поддержки проекта

## 3. Настройка Google Cloud Console

### Создание OAuth 2.0 credentials:
1. Перейдите в [Google Cloud Console](https://console.cloud.google.com/)
2. Выберите ваш проект Firebase
3. Перейдите в "APIs & Services" → "Credentials"
4. Нажмите "Create Credentials" → "OAuth 2.0 Client IDs"
5. Выберите "iOS"
6. Введите Bundle ID: `com.potatoes.TZSarafan2025-09-03`
7. Скачайте конфигурационный файл

## 4. Настройка Xcode проекта

### Info.plist настройки:
Добавьте в `Info.plist` следующие URL schemes:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>REVERSED_CLIENT_ID</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>YOUR_REVERSED_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

### Capabilities:
1. В Xcode выберите проект → Target → "Signing & Capabilities"
2. Добавьте следующие capabilities:
   - **Sign In with Apple**
   - **Keychain Sharing** (для хранения токенов)

## 5. Обновление GoogleService-Info.plist

Замените значения в файле `GoogleService-Info.plist` на реальные из вашего Firebase проекта:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CLIENT_ID</key>
    <string>YOUR_ACTUAL_CLIENT_ID</string>
    <key>REVERSED_CLIENT_ID</key>
    <string>YOUR_ACTUAL_REVERSED_CLIENT_ID</string>
    <key>API_KEY</key>
    <string>YOUR_ACTUAL_API_KEY</string>
    <key>GCM_SENDER_ID</key>
    <string>YOUR_ACTUAL_GCM_SENDER_ID</string>
    <key>PLIST_VERSION</key>
    <string>1</string>
    <key>BUNDLE_ID</key>
    <string>com.potatoes.TZSarafan2025-09-03</string>
    <key>PROJECT_ID</key>
    <string>YOUR_ACTUAL_PROJECT_ID</string>
    <key>STORAGE_BUCKET</key>
    <string>YOUR_ACTUAL_STORAGE_BUCKET</string>
    <key>IS_ADS_ENABLED</key>
    <false></false>
    <key>IS_ANALYTICS_ENABLED</key>
    <false></false>
    <key>IS_APPINVITE_ENABLED</key>
    <true></true>
    <key>IS_GCM_ENABLED</key>
    <true></true>
    <key>IS_SIGNIN_ENABLED</key>
    <true></true>
    <key>GOOGLE_APP_ID</key>
    <string>YOUR_ACTUAL_GOOGLE_APP_ID</string>
</dict>
</plist>
```

## 6. Проверка настройки

После выполнения всех шагов:

1. Очистите проект (Product → Clean Build Folder)
2. Пересоберите проект (⌘+B)
3. Запустите приложение на симуляторе или устройстве

### Ожидаемое поведение:
- Приложение должно запуститься без ошибок
- Должен отображаться экран входа с кнопками Apple и Google
- При нажатии на кнопки должна происходить аутентификация
- После успешной аутентификации должен отображаться экран приветствия

## Возможные проблемы и решения

### Ошибка "GoogleService-Info.plist не найден":
- Убедитесь, что файл добавлен в проект
- Проверьте, что файл добавлен в target приложения

### Ошибка "CLIENT_ID отсутствует":
- Проверьте, что в GoogleService-Info.plist указан правильный CLIENT_ID
- Убедитесь, что файл не поврежден

### Ошибка аутентификации Apple:
- Проверьте настройки в Apple Developer Console
- Убедитесь, что включена capability "Sign In with Apple"

### Ошибка аутентификации Google:
- Проверьте настройки в Google Cloud Console
- Убедитесь, что Bundle ID совпадает в Firebase и Google Cloud Console
- Проверьте URL schemes в Info.plist

