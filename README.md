# spec-kit-demo

# Spec Kit 最小動作確認ガイド

このガイドは、Spec Kit の基本的な動きを最短で確認するための手順です。

確認する流れは次の通りです。

1. `specify` CLI をインストールする
2. プロジェクトを初期化する
3. Spec Kit の slash command を使える状態にする
4. 仕様を作成する
5. 実装計画を作成する
6. タスクを生成する
7. 実装を実行する
8. 作成されたアプリを確認する

---

## 前提条件

以下がインストールされていることを確認します。

```bash
python --version
git --version
uv --version
```

必要なもの:

- Python 3.11 以上
- Git
- uv
- 対応する AI coding agent
  - 例: GitHub Copilot、Claude Code、Gemini CLI、Codex CLI など

---

## 1. Spec Kit CLI をインストールする

最新リリースタグを指定してインストールします。

```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v0.11.3
```

インストール後、動作確認します。

```bash
specify --help
```

`specify` のヘルプが表示されれば成功です。

---

## 2. テスト用プロジェクトを作成する

GitHub Copilot 統合で確認する例です。

```bash
specify init speckit-demo --integration copilot
cd speckit-demo
```

既存ディレクトリで試す場合は次のようにします。

```bash
mkdir speckit-demo
cd speckit-demo
specify init . --integration copilot
```

---

## 3. 生成物を確認する

初期化後、以下のようなファイル・ディレクトリが作成されていることを確認します。

```bash
ls -la
find .specify -maxdepth 3 -type f
```

主に確認するもの:

```text
.specify/
├── memory/
├── scripts/
└── templates/
```

GitHub Copilot 統合の場合は、Copilot 用の instructions や command 関連ファイルも作成されます。

### 生成されるフォルダの役割（`specify init . --integration copilot`）

画像にある主なフォルダの役割は次の通りです。

| パス | 役割 |
| --- | --- |
| `.github/agents/` | spec-kitで動くcustom agentたち。`/speckit.specify` など各コマンドで呼ばれるエージェントの振る舞いを定義します。 |
| `.github/prompts/` | 各 Speckit コマンドのプロンプトテンプレート。エージェントに渡す指示文の土台です。 |
| `.specify/extensions/` | Spec Kit 拡張機能の実体。例: `agent-context` 拡張の設定・コマンド・スクリプトを保持します。 |
| `.specify/integrations/` | 連携先（Copilot など）ごとのマニフェスト。どのファイルを導入したかを記録します。 |
| `.specify/memory/` | プロジェクトの長期メモ領域。`constitution.md` など、方針や原則を保持します。 |
| `.specify/scripts/` | 初期化後の補助シェルスクリプト群。前提チェック、feature 作成、plan/tasks 準備を行います。 |
| `.specify/templates/` | `spec.md`、`plan.md`、`tasks.md` などのテンプレート。生成ドキュメントのひな形です。 |
| `.specify/workflows/` | `specify → plan → tasks → implement` のような一連ワークフロー定義です。 |
| `.vscode/` | VS Code 用設定。Copilot の prompt 推奨表示や、`.specify/scripts/` 実行の自動承認などを設定します。 |

補足として、フォルダではありませんが次のファイルも初期化状態を管理します。

- `.specify/extensions.yml`: 有効化した拡張とフック設定
- `.specify/init-options.json`: `specify init` 実行時のオプション記録
- `.specify/integration.json`: 連携先情報（既定 integration など）

---

## 4. プロジェクト原則を作成する

AI coding agent を起動し、次のコマンドを実行します。

```text
/speckit.constitution
```

入力例:

```text
品質を重視した小さな Web アプリを作ります。
コードはシンプルに保ち、テストしやすく、不要な依存関係を増やさない方針にしてください。
```

完了後、次のファイルが作成または更新されていることを確認します。

```bash
cat .specify/memory/constitution.md
```

---

## 5. 仕様を作成する

次に、作りたい機能を指定します。

```text
/speckit.specify
```

入力例:

```text
シンプルな ToDo アプリを作りたいです。
ユーザーはタスクを追加、完了、削除できます。
各タスクにはタイトルと完了状態があります。
ログイン機能は不要です。
ブラウザ上で動作する最小構成のアプリにしてください。
```

完了後、`specs/` 配下に仕様ディレクトリが作られていることを確認します。

```bash
find specs -maxdepth 3 -type f
```

期待される例:

```text
specs/001-simple-todo-app/spec.md
```

仕様ファイルを確認します。

```bash
cat specs/*/spec.md
```

---

## 6. 技術計画を作成する

次に実装方針を指定します。

```text
/speckit.plan
```

入力例:

```text
Vanilla HTML、CSS、JavaScript で実装してください。
バックエンドは不要です。
タスクデータはブラウザの localStorage に保存してください。
ビルドツールは使わず、静的ファイルだけで動作する構成にしてください。
```

完了後、以下のようなファイルが生成されていることを確認します。

```bash
find specs -maxdepth 3 -type f
```

期待される例:

```text
specs/001-simple-todo-app/spec.md
specs/001-simple-todo-app/plan.md
specs/001-simple-todo-app/research.md
specs/001-simple-todo-app/data-model.md
specs/001-simple-todo-app/quickstart.md
```

---

## 7. タスクを生成する

実装タスクを生成します。

```text
/speckit.tasks
```

完了後、`tasks.md` が作成されていることを確認します。

```bash
cat specs/*/tasks.md
```

確認ポイント:

- タスクが段階的に分かれている
- ファイルパスが明記されている
- 並列実行可能なタスクに `[P]` が付いている
- 実装順序が分かる

---

## 8. 実装を実行する

タスクに基づいて実装します。

```text
/speckit.implement
```

完了後、プロジェクトルートにアプリ用ファイルが作成されていることを確認します。

```bash
ls -la
```

期待される例:

```text
index.html
style.css
script.js
```

---

## 9. アプリを起動して確認する

静的 HTML の場合は、ブラウザで `index.html` を開きます。

または簡易 HTTP サーバーを使います。

```bash
python -m http.server 8000
```

ブラウザで以下を開きます。

```text
http://localhost:8000
```

確認する動作:

- タスクを追加できる
- タスクを完了にできる
- タスクを削除できる
- 再読み込み後も localStorage によりタスクが残る

---

## 10. 最小確認チェックリスト

以下が確認できれば、Spec Kit の基本動作確認は完了です。

```markdown
- [ ] `specify` CLI を実行できる
- [ ] `specify init` でプロジェクトを初期化できる
- [ ] `.specify/` ディレクトリが作成される
- [ ] `/speckit.constitution` で constitution.md が作成される
- [ ] `/speckit.specify` で spec.md が作成される
- [ ] `/speckit.plan` で plan.md などが作成される
- [ ] `/speckit.tasks` で tasks.md が作成される
- [ ] `/speckit.implement` で実装ファイルが作成される
- [ ] 作成されたアプリを起動できる
```

---

## 最小検証用プロンプトまとめ

手早く試す場合は、以下だけ使えば十分です。

### `/speckit.constitution`

```text
シンプルで保守しやすいコードを重視してください。
不要な依存関係を避け、読みやすさとテストしやすさを優先してください。
```

### `/speckit.specify`

```text
シンプルな ToDo アプリを作ります。
ユーザーはタスクを追加、完了、削除できます。
ログインは不要です。
各タスクにはタイトルと完了状態があります。
```

### `/speckit.plan`

```text
Vanilla HTML、CSS、JavaScript で実装してください。
バックエンドは不要です。
データは localStorage に保存してください。
ビルドツールは使わず、静的ファイルだけで動作させてください。
```

### `/speckit.tasks`

```text
/speckit.tasks
```

### `/speckit.implement`

```text
/speckit.implement
```

---

## 補足

このガイドでは、Spec Kit の最小動作確認に集中するため、以下は扱いません。

- Extensions
- Presets
- Bundles
- GitHub Issues 連携
- 複雑なバックエンド構成
- テスト自動化
- CI/CD
- 複数エージェント比較

まずはこの手順で、**Spec Kit が仕様から実装まで成果物を段階的に生成すること**を確認してください。
