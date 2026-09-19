xml.instruct! :xml, version: "1.0", encoding: "UTF-8"

base_url = "https://globalsynergy-co.com"

xml.urlset xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9" do

  [
    "#{base_url}/",
    "#{base_url}/about",
    "#{base_url}/contact",
    "#{base_url}/inquiry",
    "#{base_url}/products",
    "#{base_url}/products/bitumen",
    "#{base_url}/posts"
  ].each do |url|
    xml.url do
      xml.loc url
    end
  end

  @products.each do |product|
    xml.url do
      xml.loc "#{base_url}#{product_path(product)}"
      xml.lastmod product.updated_at.iso8601
    end
  end

  @grades.each do |grade|
    xml.url do
      xml.loc "#{base_url}#{grade_path(grade)}"
      xml.lastmod grade.updated_at.iso8601
    end
  end

  @packings.each do |packing|
    xml.url do
      xml.loc "#{base_url}#{packing_path(packing)}"
      xml.lastmod packing.updated_at.iso8601
    end
  end

  @posts.each do |post|
    xml.url do
      xml.loc "#{base_url}#{post_path(post)}"
      xml.lastmod post.updated_at.iso8601
    end
  end

end