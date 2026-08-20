class AddTrigramIndexes < ActiveRecord::Migration[8.1]

  def change
    add_index :tags, :name,
              using: :gin,
              opclass: :gin_trgm_ops

    add_index :products, :name,
              using: :gin,
              opclass: :gin_trgm_ops

    add_index :products, :content,
              using: :gin,
              opclass: :gin_trgm_ops

    add_index :grades, :name,
              using: :gin,
              opclass: :gin_trgm_ops

    add_index :grades, :content,
              using: :gin,
              opclass: :gin_trgm_ops

    add_index :packings, :name,
              using: :gin,
              opclass: :gin_trgm_ops

    add_index :packings, :content,
              using: :gin,
              opclass: :gin_trgm_ops

    add_index :posts, :title,
              using: :gin,
              opclass: :gin_trgm_ops

    add_index :posts, :content,
              using: :gin,
              opclass: :gin_trgm_ops
  end
end
  

