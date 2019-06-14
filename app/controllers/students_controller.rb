class StudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student, only: [:show, :update, :destroy]
  # GET /students
  def index
    @student = Student.all
    json_response(@student)
  end

  # POST /students
  def create
    @student = Student.create!(student_params)
    json_response(@student, :created)
  end

  # GET /students/:id
  def show
    json_response(@student)
  end

  # PUT /students/:id
  def update
    @student.update(student_params)
    head :no_content
  end

  # DELETE /students/:id
  def destroy 
    @student.destroy
    head :no_content
  end

  # create students csv
  def create_students_csv
    @students = Student.all
    csv = @students.to_csv

    file = StringIO.new(csv)
    foo = Studentcsv.new
    foo.csv = file
    foo.csv.instance_write(:content_type, 'text/csv')
    foo.csv.instance_write(:file_name, "students-#{Date.today}.csv")
    foo.save!
    json_response("Student CSV File Created Successfully!, visit '/downloadstudents' endpoint.")
  end

  # download created students csvs (ordered by last created)
  def download_students
    @studentscsv = []
    Studentcsv.all.order("created_at DESC").each do |record|
      @studentscsv << "http://www.localhost:3000#{record.csv.url}"
    end
    json_response(@studentscsv)
  end

  private

  def student_params
    # whitelist params
    params.permit(:name)
  end

  def set_student
    @student = Student.find(params[:id])
  end
end
