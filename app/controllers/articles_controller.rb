class ArticlesController < ApplicationController
#before_action :authenticate_user! , only: [:create, :new]
before_action :authenticate_user! , except: [:show, :index]
before_action :set_article , except: [:new, :index,:create]
before_action :authenticate_editor!, only: [:create, :new, :update]
before_action :authenticate_admin!, only: [:destroy, :publish]
#GET /articles
  def index
    #Todos los registros
  #  @articles=  Article.all
  #@articles=  Article.where(state: "published") es equivalente a usar la gema aasm:
#  @articles=  Article.published
#  @articles=  Article.publicados.ultimos
@articles=  Article.paginate(page: params[:page],per_page: 10).publicados.ultimos
  end
#GET /articles/:id
  def show
    #Encontrar un registro por su id
  ##  @article=  Article.find(params[:id])
    #where Si quisieramos todos los artículos que tuviera la palabra hola en el body escrbiríamos
    #Article.where(" body LIKE ? ","%hola%")
    #Si en lugar de find quisiéramos hacer where pondríamos
    #Artivle.where(" id= ?",params[:id]), que devolvería un arreglo con un único elemento
    @article.update_visits_count
    @comment= Comment.new
  end
#GET /articles/new
def new
  #
@article=  Article.new
@categories=Category.all

end

def edit
##@article=Article.find(params[:id])

end
#POST /articles
#
  def create
    #INSER INTO
    #@article = Article.new(title: params[:article][:title],
    #                      body: params[:article][:body])
    #Con strong params, sería:
  ## RM @article = Article.new(article_params)
  @article = current_user.articles.new(article_params)

  if @article.categories == []
    puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>> vengo vacío>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  end
  @article.categories = params[:categories]


  if @article.save
    redirect_to @article
  else
    render :new
  end

  end
#DELETE /articles/:id
  def destroy
    #DELETE FROM articles
    @article=Article.find(params[:id])
    @article.destroy #Destroy elimina el objeto de la BD
    redirect_to articles_path
  end

  #PUT /articles/:id
  def update
    #UPDATE
    #@article.update_attibutes({title: 'Nuevo título'})
  ##  @article=Article.find(params[:id])
    if @article.update(article_params)
      redirect_to @article
    else
      render :edit
    end

  end

def publish
  @article.publish!
  redirect_to @article
end
private

def set_article
    @article=Article.find(params[:id])
end

def article_params
    params.require(:article).permit(:title,:body, :cover, :categories)
    #Se requiere el artículo y se permiten solo los campos que queremos que se les dé valor, no sobre otros que nosotro controlamos.
end

end
