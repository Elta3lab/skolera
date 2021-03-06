class StudentCoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student, except: [:all_students_courses, :edit_course_student, :download_students_courses, :create_students_courses_csv]
  before_action :set_student_studentcourse, only: [:show, :update, :destroy]

  # GET /students/:student_id/student_courses
  def index
    json_response(@student.student_courses)
  end

  # GET /students/:student_id/student_courses/:id
  def show
    json_response(@studentcourse)
  end

  # POST /students/:student_id/student_courses
  def create
    @student.student_courses.create!(student_course_params)
    json_response(@student, :created)
  end

  # PUT students/:student_id/student_courses/:id  (edit the course_id only)
  def update
    @studentcourse.update(course_id: params[:course_id])
    json_response(@studentcourse)
  end

  # DELETE /students/:student_id/student_courses/:id
  def destroy
    @studentcourse.destroy
    head :no_content
  end

  # PUT /editcoursestudent/:id (edit the student_id only)
  def edit_course_student
    StudentCourse.find_by!(id: params[:id]).update(student_id: params[:student_id])
    json_response(StudentCourse.find_by(id: params[:id]))
  end

  # get /allstudentscourses (to get all students courses records)
  def all_students_courses
    json_response(StudentCourse.all)
  end

  # create students_courses csv
  def create_students_courses_csv
    GenerateStudentsCoursesCsvJob.perform_later
    json_response("Creating StudentsCourses CSV file..., visit '../downloadstudentscourses' endpoint and refresh.")
  end

  # download created students_courses csvs (ordered by last created)
  def download_students_courses
    csv = []
    Csv.where(kind: "students_courses").order("created_at DESC").each do |record|
      csv << request.base_url + record.csv.url
    end
    json_response(csv)
  end

  private

  def student_course_params
    params.permit(:student_id, :course_id)
  end

  def set_student
    @student = Student.find(params[:student_id])
  end

  def set_student_studentcourse
    @studentcourse = @student.student_courses.find_by!(id: params[:id]) if @student
  end
end
