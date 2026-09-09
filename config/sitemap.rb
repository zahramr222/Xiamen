SitemapGenerator::Sitemap.default_host = 'https://xiamen-co.com'

SitemapGenerator::Sitemap.create do
  add '/', changefreq: 'daily', priority: 1.0
  add '/about', changefreq: 'monthly', priority: 0.8
  add '/contact', changefreq: 'monthly', priority: 0.7
  add '/inquiry', changefreq: 'monthly', priority: 0.7

  add '/products', changefreq: 'weekly', priority: 0.9

  Product.find_each do |product|
    add product_path(product), 
        lastmod: product.updated_at, 
        changefreq: 'weekly',
        priority: 0.8
  end

  if defined?(Grade)
    add '/grades', changefreq: 'weekly', priority: 0.8

    Grade.find_each do |grade|
      add grade_path(grade),
          lastmod: grade.updated_at,
          changefreq: 'weekly',
          priority: 0.7
    end
  end

  if defined?(Packing)
    add '/packings', changefreq: 'weekly', priority: 0.8

    Packing.find_each do |packing|
      add packing_path(packing),
          lastmod: packing.updated_at,
          changefreq: 'weekly',
          priority: 0.7
    end
  end

  if defined?(Post)
    add '/posts', changefreq: 'weekly', priority: 0.8

    Post.find_each do |post|
      add post_path(post),
          lastmod: post.updated_at,
          changefreq: 'weekly',
          priority: 0.7
    end
  end
end