class PagesController < ApplicationController
  def about
    @breadcrumbs = [
      { label: "About" }
    ]
  end

  def contact
    @breadcrumbs = [
      { label: "Contact" }
    ]
  end
end