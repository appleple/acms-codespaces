<?php

// a-blog cms インストーラー（/setup/）の DB 入力欄の初期値。
// setup.sh が展開時に web/setup/lib/db_default.php へ配置する。
// 値は compose.yaml の db サービス（MySQL）に一致させている。
$dbDefaultHost     = 'db';
$dbDefaultName     = 'acms';
$dbDefaultCreate   = ''; // '' or 'checked'（DB は compose 側で作成済みのため未チェック）
$dbDefaultUser     = 'root';
$dbDefaultPass     = 'root';
$dbDefaultPrefix   = 'acms_';
