# Python ルール

## 開発環境

- **Linter/Formatter**: ruff

## プロジェクト構造

### パッケージ配置

```
project/
├── src/              # ソースコード
│   └── package/      # パッケージ名
└── requirements.txt  # 依存関係
```

## コーディング規約

### フォーマット

- 括弧の内側にスペースを入れる
  ```python
  def function_name( arg1, arg2 ):
      result = some_func( arg1, arg2 )
  ```
- キーワード引数の `=` 前後にスペースを入れる
  ```python
  func( keyword = value )
  ```

### 型ヒント

- 関数の引数と戻り値には型ヒントを付ける
- `typing` モジュールを活用する（`List`, `Dict`, `Optional`, `Tuple` 等）

### docstring とコメント

- Google スタイルの docstring を使用する
  ```python
  def function_name(arg1: str, arg2: int) -> bool:
      """Brief description of the function

      Args:
          arg1 (str): Description of arg1
          arg2 (int): Description of arg2

      Returns:
          bool: Description of return value
      """
  ```
- コメントは簡潔な英語で記述する

### インポート

- パッケージ内のモジュールは絶対インポートを使用する
  ```python
  from package.module import ClassName
  ```

### 定数の定義

- Enum ではなく、クラスで定数を定義する
  ```python
  class GraphType:
      SPAM = 'spam'
      SPF = 'spf'
      DKIM = 'dkim'
  ```

### クラス設計

- プロパティには `@property` デコレータを使用する
- 継承を活用し、適切な抽象化を行う
