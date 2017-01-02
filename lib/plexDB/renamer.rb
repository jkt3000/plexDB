module PlexDB

  class Renamer

    VIDEO_TYPES = %w| .mp4 .mkv .avi .divx |
    SUB_TYPES   = %w| .sub .idx .srt |
    MIN_SIZE    = 200.megabytes

    def self.rename(files, relative_path: '', force: false, preview: false)
      files.each do |file|
        fo = FileObj.new(file, relative_path)

        next unless VIDEO_TYPES.include?(fo.ext)
        next if File.size(file) < MIN_SIZE
        next unless record = PlexDB.find_by_filename(fo.name)

        # build new entry
        template = record.type == 'TV' ? PlexDB::Templates.tv_template : PlexDB::Templates.movie_template
        new_file = template.render(record.to_liquid)
        new_path = File.join(relative_path, File.dirname(new_file))

        # ask for confirmation
        make_new_path(new_path)
        move_file(file, new_file)
        move_subs(fo, new_path)
        remove_old_path(fo)
      end
      # for each file, check if valid video type 
      #   next unless file is video type
      #   find entry in plexdb
      #   if found,
      #     determine what new filename/path will be.
      #     extract new relative_path => relative_path + new_path
      #     ask for confirmation for changes:
      #     - move file to new location
      #     - move all sub files to new path
      #     - delete all non-movie files
      #     - delete old path
      #     if ok, execute
      #     if not ok, skip to next file
    end

    def self.make_new_path(new_path)
    end

    def self.move_file(fo, new_file)
    end

    def self.move_subs(fo, new_path)
      # find all files
      # move all SUB_TYPES to new path
    end

    def self.remove_old_path(fo)
      # make sure there is no more movie files of a certain size
      # if ok, then rm -rf the path
    end



  end

  class FileObj

    attr_reader :name, :path, :rel_path, :ext

    def initialize(file, path)
      @name     = File.basename(file)
      @path     = File.dirname(file)
      @rel_path = @path.gsub(path, '')
      @ext      = File.extname(file)
    end
  end

end