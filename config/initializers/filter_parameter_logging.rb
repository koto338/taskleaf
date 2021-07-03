# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
# パラメータの値を隠してログ出力　（デフォルトでpasswardが設定されている）
Rails.application.config.filter_parameters += [:password]
