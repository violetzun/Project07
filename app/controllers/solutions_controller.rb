class SolutionsController < ApplicationController

def create
@project = Project.find(params[:project_id])
@solution = @project.solutions.create(solution_parameters)
redirect_to @project
end

private
def solution_parameters
params.require(:solution).permit(:name,:explanation)
end
end
