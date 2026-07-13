<?php
// GitHub Codespaces 配下でのみ、公開ドメインと HTTPS を $_SERVER に強制する前処理。
// （php.ini の auto_prepend_file で全 PHP リクエストの前に実行される）
//
// 背景: Codespaces は外部を HTTPS(443)+サブドメインで公開する一方、コンテナへは
// localhost 系 / 内部ポート付きの Host で HTTP 転送する。そのままだと a-blog cms が
// "localhost" や ":8080" 付きの不正な絶対URLを生成し、404 / ドメイン不一致になる。
//
// 対策: Codespaces が必ず提供する環境変数から「本当の公開ホスト」を組み立て、
// a-blog cms が参照する $_SERVER を上書きする。ヘッダに依存しないため確実。
// ローカル(docker compose)ではこれらの環境変数が空なので何も起きない。
$csName = getenv('CODESPACE_NAME');
$csDomain = getenv('GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN');
$csPort = getenv('ACMS_CODESPACES_PORT');
if ($csPort === false || $csPort === '') {
    $csPort = '8080'; // compose の公開ポートに合わせる
}

if (!empty($csName) && !empty($csDomain) && PHP_SAPI !== 'cli') {
    $csHost = $csName . '-' . $csPort . '.' . $csDomain; // 例: cuddly-...-8080.app.github.dev
    $_SERVER['HTTP_HOST'] = $csHost;
    $_SERVER['SERVER_NAME'] = $csHost;
    $_SERVER['HTTPS'] = 'on';
    $_SERVER['SERVER_PORT'] = '443';
    $_SERVER['HTTP_X_FORWARDED_PROTO'] = 'https';
    unset($csHost);
}
unset($csName, $csDomain, $csPort);
