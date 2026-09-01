# db/seeds.rb

puts "========================================"
puts "STARTING DATABASE SEED"
puts "========================================"


# ============================================================
# CLEAN DATABASE
# ============================================================

puts "\nCleaning database..."

PostTag.destroy_all
Post.destroy_all
Tag.destroy_all
Product.destroy_all
GradePacking.destroy_all
Grade.destroy_all
Packing.destroy_all
Specification.destroy_all

puts "Database cleaned."


# ============================================================
# SPECIFICATIONS
# ============================================================

puts "\nCreating Specifications..."

specifications = []

10.times do
  specifications << Specification.create!(
    title: Faker::Commerce.product_name,
    content: Faker::Lorem.paragraphs(number: 3).join("\n\n")
  )
end

puts "Created #{specifications.count} specifications."


# ============================================================
# GRADES
# ============================================================

puts "\nCreating Grades..."

grades = []

20.times do
  name = "#{Faker::Commerce.product_name} Grade"

  grade = Grade.create!(
    name: name,
    slug: name.parameterize,
    content: Faker::Lorem.paragraphs(number: 2).join("\n\n")
  )

  # Grade has_many :specifications
  grade.specifications << specifications.sample

  grades << grade
end

puts "Created #{grades.count} grades."


# ============================================================
# PACKINGS
# ============================================================

puts "\nCreating Packings..."

packings = []

20.times do
  name = "#{Faker::Commerce.product_name} Packing"

  packing = Packing.create!(
    name: name,
    slug: name.parameterize,
    content: Faker::Lorem.paragraphs(number: 2).join("\n\n"),
    specification: specifications.sample
  )

  packings << packing
end

puts "Created #{packings.count} packings."


# ============================================================
# GRADE ↔ PACKING
# ============================================================

puts "\nCreating Grade ↔ Packing relationships..."

grades.each do |grade|
  selected_packings = packings.sample(rand(1..4))

  selected_packings.each do |packing|
    grade.packings << packing unless grade.packings.include?(packing)
  end
end

puts "Grade ↔ Packing relationships created."


# ============================================================
# PRODUCTS
# ============================================================

puts "\nCreating Products..."

products = []

30.times do
  name = Faker::Commerce.product_name

  product = Product.create!(
    name: name,
    slug: name.parameterize,
    content: Faker::Lorem.paragraphs(number: 3).join("\n\n"),
    specification: specifications.sample
  )

  # Product has_many :grades
  product.grades << grades.sample

  products << product
end

puts "Created #{products.count} products."


# ============================================================
# TAGS
# ============================================================

puts "\nCreating Tags..."

tag_names = [
  "wax",
  "industrial",
  "packaging",
  "plastic",
  "chemical",
  "manufacturing",
  "oil",
  "paraffin",
  "petrochemical",
  "polymer",
  "container",
  "industrial materials",
  "raw materials",
  "production",
  "export",
  "import",
  "B2B",
  "factory",
  "engineering",
  "technology",
  "quality",
  "supply chain",
  "materials",
  "industry",
  "product guide",
  "technical",
  "applications",
  "market",
  "research",
  "innovation"
]

tags = tag_names.map do |name|
  Tag.create!(
    name: name
  )
end

puts "Created #{tags.count} tags."


# ============================================================
# POSTS
# ============================================================

puts "\nCreating Posts..."

post_types = [
  "News",
  "Articles",
  "Applications"
]

posts = []

20.times do
  title = Faker::Lorem.sentence(
    word_count: rand(4..8)
  ).delete_suffix(".")

  posts << Post.create!(
    title: title,
    slug: title.parameterize,
    post_type: post_types.sample,
    content: Faker::Lorem.paragraphs(
      number: rand(3..6)
    ).join("\n\n")
  )
end

puts "Created #{posts.count} posts."


# ============================================================
# POST ↔ TAG
# ============================================================

puts "\nCreating Post ↔ Tag relationships..."

posts.each do |post|
  selected_tags = tags.sample(rand(2..6))

  selected_tags.each do |tag|
    PostTag.create!(
      post: post,
      tag: tag
    )
  end
end

puts "Post ↔ Tag relationships created."


# ============================================================
# SUMMARY
# ============================================================

puts "\n========================================"
puts "SEED COMPLETED"
puts "========================================"

puts "Specifications: #{Specification.count}"
puts "Grades:         #{Grade.count}"
puts "Packings:       #{Packing.count}"
puts "Products:       #{Product.count}"
puts "Posts:          #{Post.count}"
puts "Tags:           #{Tag.count}"
puts "PostTags:       #{PostTag.count}"
puts "GradePackings:  #{GradePacking.count}"

puts "========================================"