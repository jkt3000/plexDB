module PlexDB
  require 'fileutils'

  class Renamer

    VIDEO_TYPES = %w| .mp4 .mkv .avi .divx |
    SUB_TYPES   = %w| .sub .idx .srt |
    MIN_SIZE    = 200.megabytes

    attr_reader :curr_path, :require_confirmation, :preview_only

    def initialize(curr_path:, require_confirmation:, preview_only:)
      @curr_path            = curr_path
      @require_confirmation = require_confirmation
      @preview_only         = preview_only
    end

    def rename(file)
      return unless valid_file?(file)
      return unless record = PlexDB.find_by_filename(File.basename(file))

      new_file, new_path = process_record(record)
      old_path = File.dirname(file)


      puts "\n#{file}"
      puts "="*80
      puts "Plex Record: #{new_file}"
      make_new_path(new_path)
      move_video_file(file, File.join(new_path, new_file))
      if old_path == curr_path
        puts "File is not in subdirectory, skip the rest of the activities"
      else
        move_sub_files(old_path, new_path)
        delete_old_path(old_path)
      end
      puts "-"*80
    end

    def make_new_path(path)
      puts "=== New path: #{path}"
      if preview_only?
        puts "  mkdir -p #{path}"
      else
        if File.exist?(path)
          puts "Path already exists"
        else
          FileUtils.mkdir_p path
        end
      end
    end

    def move_video_file(src, dest)
      move_file(src, dest)
    end

    # handle case where src file is not a directory!
    def move_sub_files(src_path, dest_path)
      puts "=== Move subtitle files"
      puts "    from: #{src_path}"
      puts "    to:   #{dest_path}"

      files = Dir[File.join(src_path, "**/*")]
      files.each do |file|
        next unless SUB_TYPES.include?(File.extname(file))
        move_file_to_path(file, dest_path)
      end
    end

    def delete_old_path(path)
      puts "=== Delete path: #{path}"
      files = Dir[File.join(path, "**/*")]
      files.each do |file|
        if valid_file?(file)
          puts "Found potential video file. Abort deleting directory."
          return
        end
      end

      if preview_only?
        puts "  rm -rf #{path}"
      else
        FileUtils.rm_rf path
      end
    end

    # create new filename, path from plexDB entry
    # returns new name, new path
    def process_record(record)
      template = record.type == 'TV' ? PlexDB::Templates.tv_template : PlexDB::Templates.movie_template
      text = template.render(record.to_liquid)
      new_path = File.join(curr_path, File.dirname(text))
      new_file = File.basename(text)
      [new_file, new_path]
    end

    # determine the relative path of this file
    def rel_path(file)
      File.dirname(file)
    end

    def valid_file?(file)
      filename = File.basename(file)
      ext      = File.extname(file)
      return unless VIDEO_TYPES.include?(ext)
      return unless File.size(file) > MIN_SIZE
      true
    end


    # move src file to new path, but keep existing filename
    def move_file_to_path(src, dest_path, overwrite: false)
      dest = File.join(dest_path, File.basename(src))
      move_file(src, dest, overwrite: overwrite)
    end

    def move_file(src, dest, overwrite: false)
      puts "=== Move file"
      puts "    from: #{src}"
      puts "    to:   #{dest}"

      new_dest = valid_new_filename(dest)
      if preview_only?
        puts "  mv #{src} #{new_dest}"
      else
        FileUtils.mv src, new_dest
      end
    end

    # returns new filename that doesn't exist yet
    # if file already exists, increments to _X 
    def valid_new_filename(file)
      new_file = file
      counter = 0
      while File.exist?(new_file) do
        counter += 1
        ext = File.extname(file)
        basename = file.split(ext).first
        new_file = "#{basename}_#{counter}#{ext}"
      end
      new_file
    end

    def files_in_path(path)
      Dir[File.join(path, "**/*")]
    end

    def preview_only?
      preview_only
    end

    def require_confirmation?
      require_confirmation
    end
  end

end