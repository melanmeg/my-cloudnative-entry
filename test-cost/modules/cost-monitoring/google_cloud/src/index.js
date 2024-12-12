"use strict";

const functions = require("@google-cloud/functions-framework"); // 必須
const { WebClient } = require("@slack/web-api");
const { BigQuery } = require("@google-cloud/bigquery");
const { SecretManagerServiceClient } = require("@google-cloud/secret-manager").v1;

const resourceName = "projects/test-project-373118/secrets/test-slack-secret/versions/latest"; // SecretManager のリソース名

const channel = "#slack-test"; // 通知チャンネル名

const query = `SELECT *
    FROM \`my-project-melanmeg.test_billing_dataset.gcp_billing_export_v1_01E1E2_A01988_CBB535\`
    LIMIT 3`;

// SecretManager からシークレットを取得する関数
// ref: https://cloud.google.com/nodejs/docs/reference/secret-manager/latest#:~:text=Try%20it-,Secret_manager_service.access_secret_version,source%20code,-Secret_manager_service.add_secret_version
async function getSecret() {
  // クライアントをインスタンス化
  const client = new SecretManagerServiceClient();

  // SecretManager サービスにアクセスする
  async function accessSecretVersion() {
    const [version] = await client.accessSecretVersion({
      // バージョンは'latest'で最新バージョンを参照することも可能
      name: resourceName
    });

    const payload = version.payload.data.toString("utf8");
    return payload;
  }

  const payload = accessSecretVersion();

  return payload;
}

// BigQuery にクエリを実行する関数
// ref: https://cloud.google.com/nodejs/docs/reference/bigquery/latest#:~:text=source%20code-,Query,source%20code,-Query%20Batch
async function runQuery() {
  const bigquery = new BigQuery();

  // すべてのオプションについては、https://cloud.google.com/bigquery/docs/reference/rest/v2/jobs/query を参照してください。
  const options = {
    query: query,
    // クエリで参照されるデータセットの場所と一致する必要があります。
    location: "asia-northeast1"
  };

  // クエリをジョブとして実行する
  const [job] = await bigquery.createQueryJob(options);
  console.log(`QueryJob ${job.id} is started.`);

  // クエリが終了するのを待つ
  const [rows] = await job.getQueryResults();

  return rows[0].billing_account_id; // テスト用に billing_account_id を返す
}

// Slack にメッセージを投稿する関数
async function postMessage(message, slackBotToken) {
  const client = new WebClient(slackBotToken);
  const text = "billing_account_id: " + message + "。これもテストです!!!"; // メッセージの内容
  const response = await client.chat.postMessage({ channel, text });

  return response;
}

// HTTP リクエストを受け取る メイン関数
functions.http("send_slack_notify", (req, res) => {
  (async () => {
    const slackBotToken = await getSecret(); // Slack Botトークン

    const result = await runQuery();

    const response = await postMessage(result, slackBotToken.toString());

    if (!response.ok) {
      // 投稿に成功すると `ok` フィールドに `true` が入る。
      console.error("Failed to post message to Slack.");
      res.status(500).send("Failed to post message to Slack.");
    } else {
      console.log("Succeeded to post message to Slack.");
      res.send("ok");
    }
  })();
});
