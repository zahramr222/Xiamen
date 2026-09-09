# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_09_08_080623) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "grade_packings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "grade_id"
    t.integer "packing_id"
    t.datetime "updated_at", null: false
    t.index ["grade_id"], name: "index_grade_packings_on_grade_id"
    t.index ["packing_id"], name: "index_grade_packings_on_packing_id"
  end

  create_table "grade_tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "grade_id"
    t.bigint "tag_id"
    t.datetime "updated_at", null: false
    t.index ["grade_id"], name: "index_grade_tags_on_grade_id"
    t.index ["tag_id"], name: "index_grade_tags_on_tag_id"
  end

  create_table "grades", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.text "meta_description"
    t.string "meta_title"
    t.string "msds"
    t.string "name"
    t.integer "product_id"
    t.string "slug"
    t.datetime "updated_at", null: false
    t.index ["content"], name: "index_grades_on_content", opclass: :gin_trgm_ops, using: :gin
    t.index ["name"], name: "index_grades_on_name", opclass: :gin_trgm_ops, using: :gin
  end

  create_table "inquiries", force: :cascade do |t|
    t.string "company"
    t.string "country"
    t.datetime "created_at", null: false
    t.text "details"
    t.string "email"
    t.string "full_name"
    t.string "packing"
    t.string "phone"
    t.string "port_of_discharge"
    t.string "product"
    t.datetime "updated_at", null: false
  end

  create_table "packing_tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "packing_id"
    t.bigint "tag_id"
    t.datetime "updated_at", null: false
    t.index ["packing_id"], name: "index_packing_tags_on_packing_id"
    t.index ["tag_id"], name: "index_packing_tags_on_tag_id"
  end

  create_table "packings", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.text "meta_description"
    t.string "meta_title"
    t.string "name"
    t.string "slug"
    t.integer "specification_id"
    t.datetime "updated_at", null: false
    t.index ["content"], name: "index_packings_on_content", opclass: :gin_trgm_ops, using: :gin
    t.index ["name"], name: "index_packings_on_name", opclass: :gin_trgm_ops, using: :gin
    t.index ["specification_id"], name: "index_packings_on_specification_id"
  end

  create_table "post_tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "post_id", null: false
    t.integer "tag_id", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_post_tags_on_post_id"
    t.index ["tag_id"], name: "index_post_tags_on_tag_id"
  end

  create_table "posts", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.text "meta_description"
    t.string "meta_title"
    t.string "post_type"
    t.string "slug"
    t.text "summery"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["content"], name: "index_posts_on_content", opclass: :gin_trgm_ops, using: :gin
    t.index ["title"], name: "index_posts_on_title", opclass: :gin_trgm_ops, using: :gin
  end

  create_table "product_tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "product_id"
    t.bigint "tag_id"
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_tags_on_product_id"
    t.index ["tag_id"], name: "index_product_tags_on_tag_id"
  end

  create_table "products", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.text "meta_description"
    t.string "meta_title"
    t.string "name"
    t.string "slug"
    t.integer "specification_id"
    t.datetime "updated_at", null: false
    t.index ["content"], name: "index_products_on_content", opclass: :gin_trgm_ops, using: :gin
    t.index ["name"], name: "index_products_on_name", opclass: :gin_trgm_ops, using: :gin
    t.index ["specification_id"], name: "index_products_on_specification_id"
  end

  create_table "specifications", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.integer "grade_id"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", opclass: :gin_trgm_ops, using: :gin
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "grade_packings", "grades"
  add_foreign_key "grade_packings", "packings"
  add_foreign_key "grade_tags", "grades"
  add_foreign_key "grade_tags", "tags"
  add_foreign_key "packing_tags", "packings"
  add_foreign_key "packing_tags", "tags"
  add_foreign_key "packings", "specifications"
  add_foreign_key "post_tags", "posts"
  add_foreign_key "post_tags", "tags"
  add_foreign_key "product_tags", "products"
  add_foreign_key "product_tags", "tags"
  add_foreign_key "products", "specifications"
end
