class MallineTestsController < ApplicationController
  # GET /malline_tests
  # GET /malline_tests.xml
  def index
    @malline_tests = MallineTest.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @malline_tests }
    end
  end

  # GET /malline_tests/1
  # GET /malline_tests/1.xml
  def show
    @malline_test = MallineTest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @malline_test }
    end
  end

  # GET /malline_tests/new
  # GET /malline_tests/new.xml
  def new
    @malline_test = MallineTest.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @malline_test }
    end
  end

  # GET /malline_tests/1/edit
  def edit
    @malline_test = MallineTest.find(params[:id])
  end

  # POST /malline_tests
  # POST /malline_tests.xml
  def create
    @malline_test = MallineTest.new(params[:malline_test])

    respond_to do |format|
      if @malline_test.save
        flash[:notice] = 'MallineTest was successfully created.'
        format.html { redirect_to(@malline_test) }
        format.xml  { render :xml => @malline_test, :status => :created, :location => @malline_test }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @malline_test.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /malline_tests/1
  # PUT /malline_tests/1.xml
  def update
    @malline_test = MallineTest.find(params[:id])

    respond_to do |format|
      if @malline_test.update_attributes(params[:malline_test])
        flash[:notice] = 'MallineTest was successfully updated.'
        format.html { redirect_to(@malline_test) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @malline_test.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /malline_tests/1
  # DELETE /malline_tests/1.xml
  def destroy
    @malline_test = MallineTest.find(params[:id])
    @malline_test.destroy

    respond_to do |format|
      format.html { redirect_to(malline_tests_url) }
      format.xml  { head :ok }
    end
  end
end
