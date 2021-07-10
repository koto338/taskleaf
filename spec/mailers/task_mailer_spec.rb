require "rails_helper"

describe  TaskMailer, type: :mailer do
  # 共通的なテストデータとしてtaskというletを用意
  let(:task) { FactoryBot.create(:task, name: 'メイラーSpecを書く', description: '送信したメールの内容を確認します') }

# 　text形式のbody内容を得られやすくするためtext_bodyとhtml_bodyというletを用意
  let(:text_body) do
    part = mail.body.parts.detect { |part| part.content_type == 'text/plain; charset=UTF-8'}
    part.body.raw_source
  end
  let(:html_body) do
    part = mail.body.parts.detect { |part| part.content_type == 'text/html; charset=UTF-8'}
    part.body.raw_source
  end

  # creation_emailメソッド部分
  #creation_emailメソッドを使ってメールを生成し、生成したメールオブジェクトをmailという名前で参照できるようにするletを定義
  describe '#creation_email' do
    let(:mail) { TaskMailer.creation_email(task) }
    # mailに対して期待する内容
    it '想定どおりのメールが生成されている' do
      # ヘッダ
      expect(mail.subject).to eq('タスク作成完了メール')
      expect(mail.to).to eq(['user@example.com'])
      expect(mail.from).to eq(['taskleaf@example.com'])


      # text形式の本文
      expect(text_body).to match('以下のタスクを作成しました')
      expect(text_body).to match('メイラーSpecを書く')
      expect(text_body).to match('送信したメールの内容を確認します')

      # html形式の本文
      expect(html_body).to match('以下のタスクを作成しました')
      expect(html_body).to match('メイラーSpecを書く')
      expect(html_body).to match('送信したメールの内容を確認します')
    end
  end
end
  