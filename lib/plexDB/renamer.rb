module PlexDB

  class Renamer

    VIDEO_TYPES = %w| .mp4 .mkv .avi .divx |
    SUB_TYPES   = %w| .sub .idx .srt |
    MIN_SIZE    = 200.megabytes

    attr_reader :relative_path, :force, :preview

    def initialize(path, force: false, preview: false)
      @relative_path = path
      @force         = force
      @preview       = preview
    end

    def rename(files)
      files.each do |file|
        next unless entry = valid_file?(file)
        new_file, new_path = build_new_file(entry)

        # preview changes
        if preview?
          make_new_path(new_path, preview: true)
          move_file(file, new_file, preview: true)
          move_subs(file, new_path, preview: true)
          remove_old_path(file, preview: true)
        end
        if confirmed?
          make_new_path(new_path)
          move_file(file, new_file)
          move_subs(file, new_path)
          remove_old_path(file)
        end
      end
    end

    def preview?
      false
    end

    def confirmed?
      true
    end


    def make_new_path(path, preview: false)
      p "make new path"
      # create new path
    end

    def move_file(file, dest, preview: false)
      p "Move file"
      # move file file => new dest
    end

    def move_subs(file, dest, preview: false)
      p "Move sub files"
      # find any sub files,
      # if found, move to new dest
    end

    def delete_old_path(path, preview: false)
      p "Delete old path"
      # get relative path to remove
      # return if valid movie files exist
      # else rm -rf path
    end

    # returns entry if file is a valid movie file,
    # greater than min size, 
    # and found in plexdb
    # otherwise returns nil
    def valid_file?(file)
      filename = File.basename(file)
      ext      = File.extname(file)
      return unless VIDEO_TYPES.include?(ext)
      return unless File.size(file) > MIN_SIZE
      PlexDB.find_by_filename(filename)
    end

    # create new filename, path for plexDB entry
    def build_new_file(entry)

        # build new entry
        # template = record.type == 'TV' ? PlexDB::Templates.tv_template : PlexDB::Templates.movie_template
        # new_file = template.render(record.to_liquid)
        # new_path = File.join(relative_path, File.dirname(new_file))
    end
  end

end