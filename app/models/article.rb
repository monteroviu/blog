class Article < ApplicationRecord
include AASM
#La tabla: Coge el nombre de la clase, lo pluraliza, esta será la tabla en la BD: 'articles'
#Los Campos:Se crearán automáticamente usando el Active record=> article.title() nos devuelve "el título del artículo"
#Escribir métodos
belongs_to :user
has_many :comments, dependent: :destroy
has_many :has_categories, dependent: :destroy
has_many :categories, through: :has_categories

after_create :send_mail

validates :title, presence:true, uniqueness:true
validates :body, presence:true, length: {minimum: 20}

validate do
  if @categories == nil
   #puts ">>>>>>>>>>>>>>>>>>>>>>>>validate_empty_categories>>>>>>>>>>>>>>>>>>>>>>"
   #errors.add(:base, 'Debe escoger al menos una categoría')
  #  return false
  end
end

before_save :set_visits_count
after_create :save_categories


has_attached_file :cover, styles: {medium:"1280x720", thumb:"800x600"}  # Tiene un archivo adjunto llamado cover con dos versiones de tamaño
validates_attachment_content_type :cover, content_type: ["image/jpeg", "image/gif", "image/png", "image/jpg"] #content_type: /\image\/.*\Z/ # Validación para evitar ataques y solo se suban los archivos de unas extensiones predefinidas

scope :publicados, -> {where(state: "published")}
# para que no sobreescriba la paginación quitemos el límite scope :ultimos, ->{order("created_at DESC").limit(10)}
scope :ultimos, ->{order("created_at DESC")}
#Custom setter
def categories=(value)
  @categories=value
end

def update_visits_count

  self.save if self.visits_count.nil?
  #puts ">>>>>>>>>>>>>>>>>>Soy nil>>>>>>>>>>>>>>>>>>>>>" if self.visits_count.nil?
  self.update_columns(visits_count: self.visits_count.to_i + 1)

end

aasm column: "state" do
  state :in_draft, initial: true
  state :published

  event :publish do
  transitions from: :in_draft, to: :published
  #  transitions :from=> :in_draft, :to => :published
  end

  event :unpublish do
    transitions from: :published, to: :in_draft
  end

end

private

def send_mail
  #ArticleMailer.new_article(self).deliver_later
  ArticleMailer.new_article(self).deliver_now
  puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  puts ">>>>>>>>>>>>>>>>>>>>entro send mail>>>>>>>>>>>>>>>>>>>>>>>>>>"
  puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
end
def save_categories
  if @categories != []
    @categories.each do |category_id|
      HasCategory.create(category_id: category_id, article_id: self.id)
        #puts ">>>>>>>>>>>>>>>>>>>>entro  a save_categories>>>>>>>>>>>>>>>>>>>>>>>>>>"
      puts category_id
        #puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    end
  end
end

def set_visits_count
  #puts ">>>>>>>>>>>>>>>>>entro  a set_visits_count>>>>>>>>>>>>>>>>>>>>"
  self.visits_count ||= 0
end


end
