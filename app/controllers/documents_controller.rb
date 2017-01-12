class DocumentsController < ApplicationController
  before_action :verify_user
  before_action :load_document, only: [:update, :destroy]

  def index
    @categories = Category.all
    @document_support = Supports::DocumentSupport.new
  end

  def new
    @document = Document.new
  end

  def create
    @document = current_user.documents.build document_params
    if @document.save
      flash[:success] = t ".create_success"
      DocumentMailer.delay.upload_document(@document, current_user)
      redirect_to root_path
    else
      render :new
    end
  end

  private
  def document_params
    params.require(:document).permit :name, :description, :attachment,
      :category_id
  end

  def load_document
    @document = Document.find_by id: params[:id]
    unless @document
      flash.now[:warning] = t "document.not_found"
      render_404
    end
  end
end
