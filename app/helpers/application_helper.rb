module ApplicationHelper
  def flash_background_color(type)
    case type.to_sym
    when :success then "bg-[#62CB93]"
    when :alert  then "bg-[#CBB162]"
    when :error  then "bg-[#B03B3B]"
    else "bg-[#C6E4EC]"
    end
  end

  # OGP
  def default_meta_tags
    {
      site: '距離感どのくらい？',  # サイトの名前
      title: '距離感どのくらい？',  # タイトル
      reverse: true, # タイトルとサイト名の順序を逆にするかどうか
      charset: 'utf-8', # HTMLの文字エンコーディング
      description: '2地点間の距離を3択から選ぶクイズアプリです。',  # ページの説明 検索エンジンやSNSで表示される場合有り
      keywords: 'クイズアプリ,地図クイズ,距離クイズ,googlemap,距離感',  # ページのキーワード
      canonical: 'https://sence-of-distance.com/ranking ', # ページの正規URL
      separator: '|',
      og: { # Open Graphプロトコルのためのメタタグ情報
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: 'https://sence-of-distance.com/ranking ',
        image: image_url('OGP_image.png'),# 配置するパスやファイル名によって変更
        local: 'ja-JP',
      },
      twitter: { # Twitterカードのためのメタタグ情報
        card: 'summary_large_image', # Twitterで表示する場合は大きいカードに変更
        site: '@https://x.com/kin_doo_nichi', # アプリの公式Twitterアカウントがあればアカウント名を記載
        image: image_url('OGP_image.png'),# カードで表示される画像。配置するパスやファイル名によって変更
      }
    }
  end
end
