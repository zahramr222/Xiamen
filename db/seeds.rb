# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb

# db/seeds.rb

puts "Cleaning database..."

PostTag.destroy_all
Post.destroy_all
Tag.destroy_all
Product.destroy_all
GradePacking.destroy_all
Grade.destroy_all
Packing.destroy_all
Specification.destroy_all

puts "Creating Specifications..."

specifications = []

10.times do
  specifications << Specification.create!(
    title: Faker::Commerce.product_name,
    content: Faker::Lorem.paragraphs(number: 3).join("\n\n")
  )
end

puts "Created #{specifications.count} specifications."


puts "Creating Grades..."

grades = []

20.times do
  name = "#{Faker::Commerce.product_name} Grade"

  grades << Grade.create!(
    name: name,
    slug: name.parameterize,
    content: Faker::Lorem.paragraphs(number: 2).join("\n\n"),
    specification: specifications.sample
  )
end

puts "Created #{grades.count} grades."


puts "Creating Packings..."

packings = []

20.times do
  name = "#{Faker::Commerce.product_name} Packing"

  packings << Packing.create!(
    name: name,
    slug: name.parameterize,
    content: Faker::Lorem.paragraphs(number: 2).join("\n\n"),
    specification: specifications.sample
  )
end

puts "Created #{packings.count} packings."


puts "Creating Grade ↔ Packing relationships..."

grades.each do |grade|
  packings.sample(rand(1..4)).each do |packing|
    grade.packings << packing unless grade.packings.include?(packing)
  end
end

puts "Grade ↔ Packing relationships created."


puts "Creating Products..."

products = []

30.times do
  name = Faker::Commerce.product_name

  products << Product.create!(
    name: name,
    slug: name.parameterize,
    content: Faker::Lorem.paragraphs(number: 3).join("\n\n"),
    specification: specifications.sample,
    grade: grades.sample
  )
end

puts "Created #{products.count} products."




puts "Creating Tags..."

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


puts "Creating Posts..."

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


puts "Creating Post ↔ Tag relationships..."

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


puts "----------------------------------------"
puts "SEED COMPLETED"
puts "----------------------------------------"

puts "Specifications: #{Specification.count}"
puts "Grades:         #{Grade.count}"
puts "Packings:       #{Packing.count}"
puts "Products:       #{Product.count}"
puts "Posts:          #{Post.count}"
puts "Tags:           #{Tag.count}"
puts "PostTags:       #{PostTag.count}"
puts "GradePackings:  #{GradePacking.count}"
puts "----------------------------------------"

