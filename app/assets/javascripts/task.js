// window.onloadの変わりの書き方
// ページの読み込みが完了したタイミングで処理を開始する
document.addEventListener('turbolinks:load', function() {
  document.querySelectorAll('td').forEach(function(td) {
    td.addEventListener('mouseover', function(e) {
      e.currentTarget.style.backgroundColor = '#eff';
    });
    
    td.addEventListener('mouseout', function(e) {
      e.currentTarget.style.backgroundColor = '';
    });
  });
});

// 削除したタスクを非表示にする
document.addEventListener('turbolinks:load', function() {
  // document.querySelectorAll('.delete')は削除リンクの要素群を返す。
  // forEachを使って、各要素にaddEventListener()を使ってajax:successイベントに対応する処理を定義
  document.querySelectorAll('.delete').forEach(function(a) {
    a.addEventListener('ajax:success', function() {
      // parentNodeは要素の親要素を返す
      // 削除リンクを表すオブジェクトがaという変数に入り、parentNodeで削除リンクの親要素、td要素を返す
      var td = a.parentNode;
      // tdの親要素tr要素を取得
      var tr = td.parentNode;
    　// tr要素のスタイルを変更して非表示
      tr.style.display = 'none';
    });
  });
});