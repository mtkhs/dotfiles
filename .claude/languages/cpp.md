# C++ルール

## 開発環境

### Windows

- **Visual Studio 2022** を使用
- C++開発ツールをインストール
- 64bitターゲットでビルド

### Linux

- **GCC** または **Clang** を使用
- 64bitターゲットでビルド

### ビルドシステム

#### 共通

- **CMake** を使用してプロジェクト管理

#### Windows

```powershell
cmake -B build -G "Visual Studio 17 2022" -A x64
cmake --build build --config Release
```

#### Linux

```bash
cmake -B build
cmake --build build --config Release
# または
make -C build
```

## プロジェクト構造（共通）

```
project/
├── src/              # ソースファイル
├── include/          # ヘッダファイル
└── CMakeLists.txt    # CMake設定
```

## コーディング規約

### メモリ管理

- スマートポインタ（`std::unique_ptr`, `std::shared_ptr`）を優先する
- `new`/`delete` を直接使う場合は、対応を必ず確認する
- メモリリークを防ぐ
- ポインタチェックには `nullptr` を使用する

### エラー処理

- 関数の戻り値でエラーを返す
- エラー時は適切なエラーコードを返す

### ヘッダファイル

- インクルードガードを使用する
  ```c
  #ifndef HEADER_NAME_H
  #define HEADER_NAME_H
  // ...
  #endif
  ```
