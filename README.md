# wg-easy-build

独立为 [wg-easy/wg-easy](https://github.com/wg-easy/wg-easy) 打包的仓库，不是 fork，不保存上游源码，也不向上游源码应用补丁。

## 构建与下载

每天检查上游最新正式 Release；已打包的版本自动跳过。推送本仓库 main 也会检查。
Actions → Build upstream release → Run workflow：可填写 `upstream_tag` 指定版本，`rebuild` 可重新构建已有版本。

[下载最新打包版本](https://github.com/weidix/wg-easy-build/releases/latest)，主文件保持为 `wg-easy-output.tar.gz`。
每个 Release 对应上游 tag，并附带 `build-info.json`（上游 commit、打包仓库 commit、构建链接）和 `SHA256SUMS.txt`。
校验：`sha256sum -c SHA256SUMS.txt`。

## 运行环境与边界

产物为 Linux x86_64 / musl（Alpine），需要 Node.js 24，并非跨平台静态二进制或完整 Docker 镜像。
构建使用上游锁文件和 `pnpm install --frozen-lockfile`。结束后检查上游工作树，文件发生变更时拒绝发布。
仓库仅维护打包逻辑；上游软件版权和许可归原项目，原始许可随包提供。

wg-easy 包保留 `.output` 的目录布局，包含数据库 migrations 和 CLI。libsql 像上游 Dockerfile 一样在独立临时目录安装，再复制进运行产物，不修改上游 package.json 或锁文件。运行主入口为 `node server/index.mjs`；系统仍需配置 WireGuard、iptables 等上游运行依赖。
