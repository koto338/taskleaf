class TasksController < ApplicationController
  before_action :set_task, only:[:show, :edit, :update, :destroy]

  def index
    @q = current_user.tasks.ransack(params[:q])
    @tasks = @q.result(distinct: true).page(params[:page]).per(10)
    
    # format.htmlはhtmlでアクセスされた場合、format.csvはCSVとしてアクセスされた場合にそれぞれ実行される
    respond_to do |format|
      # HTMLフォーマットは何も処理をしない。デフォルトのslimが表示される
      format.html
      # send_dateを使ってレスポンスを送り出し、送り出したデータをブラウザからファイルとしてダウンロードできるようにする
      # レスポンスの内容はTask.generate_csvが生成するCSVデータとする
      # ファイル名は、ダウンロードするたび異なるように、現在時刻を使って作成
      format.csv { send_data @tasks.generate_csv, filename: "tasks-#{Time.zone.now.strftime('%Y%m%d%S')}.csv" }
    end
  end

  # 画面上のフィールドからアップロードされたファイルオブジェクトを引数に呼び出す
    # ファイルの内容を、ログインしているユーザーのタスク群として登録する
    def import
      current_user.tasks.import(params[:file])
      redirect_to tasks_url, notice: "タスクを追加しました"
    end
    
  def show 
  end

  def new
    @task = Task.new
  end  

  def edit
  end

  def update
    @task.update!(task_params)
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を更新しました。"
  end

  def destroy
    @task.destroy
  end

  def create
    @task = current_user.tasks.new(task_params)

    if params[:back].present?
      render :new
      return
    end

    if @task.save
      TaskMailer.creation_email(@task).deliver_now
      SampleJob.perform_later
      redirect_to @task, notice: "タスク「#{@task.name}」を登録しました。"
    else
      render :new      
    end
  end

  def confirm_new
    @task = current_user.tasks.new(task_params)
    render :new unless @task.valid?
  end

  private
  
  def task_params
    params.require(:task).permit(:name, :description, :image)
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end
end
