require 'rails_helper'

describe 'タスク管理機能', type: :system do
  describe '一覧表示機能' do
    before do
    #   ユーザーAを作成しておく
      user_a = FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com')
    #   制作者がユーザーAであるタスクを作成しておく
      FactoryBot.create(:task, name: '最初のタスク', user: user_a)
    end

    context 'ユーザーAがログインしているとき' do
      before do
        # ユーザーAでログインする
        # ログイン画面にアクセスする
        visit login_path
        # メールアドレスを入力する
        fill_in 'session[email]', with: 'a@example.com'
        # パスワードを入力する
        fill_in 'session[password]', with: 'password'
        # ログインするボタンを押す
        click_button 'ログインする'
      end
    
      it 'ユーザーAが作成したタスクが表示される' do
        # 作成済みのタスクの名称が画面上に表示されていることを確認
        expect(page).to have_content '最初のタスク'
      end
    end

    context 'ユーザーBがログインしているとき' do
      before do
        # ユーザーBを作成しておく
        FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com')
        # ユーザーBでログインする
        visit login_path
        fill_in 'session[email]', with: 'b@example.com'
        fill_in 'session[password]', with: 'password'
        click_button 'ログインする'
      end

      it 'ユーザーAが作成したタスクが表示されない' do
        # ユーザーAが作成したタスクの名称が画面上に表示されていないことを確認
        expect(page).to have_no_content '最初のタスク'
      end 
    end
  end
end