def bitumen
  @sub_products = [
    { name: "Oxidized Bitumen", 
      path: products_oxidized_bitumen_path, 
      description: "High-quality oxidized bitumen for industrial applications.",
      icon: "fa-solid fa-fire" },
    { name: "Penetration Bitumen", 
      path: products_penetration_bitumen_path, 
      description: "Standard penetration grade bitumen for road construction.",
      icon: "fa-solid fa-road" },
    { name: "Cutback Bitumen", 
      path: products_cutback_bitumen_path, 
      description: "Bitumen dissolved in solvent for cold application.",
      icon: "fa-solid fa-droplet" },
    { name: "Emulsion Bitumen", 
      path: products_emulsion_bitumen_path, 
      description: "Bitumen emulsion for surface dressing and maintenance.",
      icon: "fa-solid fa-water" }
  ]
  
  # Find or create product objects for linking
  @oxidized_bitumen = Product.find_by(name: "Oxidized Bitumen") || Product.new(name: "Oxidized Bitumen", slug: "oxidized-bitumen")
  @penetration_bitumen = Product.find_by(name: "Penetration Bitumen") || Product.new(name: "Penetration Bitumen", slug: "penetration-bitumen")
  @cutback_bitumen = Product.find_by(name: "Cutback Bitumen") || Product.new(name: "Cutback Bitumen", slug: "cutback-bitumen")
  @emulsion_bitumen = Product.find_by(name: "Emulsion Bitumen") || Product.new(name: "Emulsion Bitumen", slug: "emulsion-bitumen")
  
  @breadcrumbs = [
    { label: "Products", path: products_path },
    { label: "Bitumen" }
  ]
end