class Task < ApplicationRecord
    has_one_attached :image

    validates :name, presence: true
    validates :name, length: { maximum: 30 }
    validate :validate_name_not_including_comma

    belongs_to :user
    
    scope :recent, -> { order(created_at: :desc) }

    def self.ransackable_attributes(auth_object = nil)
      %w[name created_at]
    end

    def self.ransackable_associations(auth_object = nill)
      []
    end
    
    # ＣSVデータにどの属性をどの順番で出力するかcsv_attributesクラスメソッドに定義
    def self.csv_attributes
      ["name", "description", "created_at", "updated_at"] 
    end

    def self.generate_csv
      # CSV.generateを使ってCSVデータの文字列を出力
      CSV.generate(headers: true) do |csv|
        # CSVの1行目としてヘッダを出力
        csv << csv_attributes
        # allメソッドで全タスクを取得、1レコードごとにCSV1行を出力
        all.each do |task|
          csv << csv_attributes.map{ |attr| task.send(attr) }
        end
      end
    end
    
    # fileという引数で、アップロードされたファイルの内容にアクセスするためのオフジェクトを受け取る
    def self.import(file)
      # CSV.foreachを使って、CSVファイルを1行ずつ読み込む。 headers: trueの指定により、1行目をヘッダとして無視する
      CSV.foreach(file.path, encoding: 'Shift_JIS:UTF-8', headers: true) do |row|
         # CSV一行ごとに、Taskインスタンスを生成(newはTASK.newを同意。selfがTaskの状態なので省略)
        task = new
        # 生成したTaskインスタンスの各属性に、CSVの一行の情報を加工して入れ込む
        task.attributes = row.to_hash.slice(*csv_attributes)
        # Taskインスタンスをデータベースに登録する
        task.save!
      end
    end

    private

    def validate_name_not_including_comma
        errors.add(:name, 'にカンマを含めることはできません。') if name&.include?(',')
    end
end
