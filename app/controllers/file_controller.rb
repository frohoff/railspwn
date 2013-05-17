class FileController < ApplicationController
  def show
    if params[:file]
      send_file "files/#{params[:file]}"
    else
      @files = Dir.entries("files").select { |fn| fn && !fn.start_with?('.') }
      puts @files
    end
  end
end
