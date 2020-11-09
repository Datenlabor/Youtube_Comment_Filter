# frozen_string_literal: true

module GetComment
  module Repository
    # Repository for Comments
    class Comments
      # Get all entities from database
      def self.all
        Database::CommentOrm.all.map { |db_project| rebuild_entity(db_project) }
      end

      # Find the db_record that matches the entity
      def self.find(entity)
        find_by_video_id(entity.video_id)
      end

      def self.find_by_video_id(video_id)
        db_records = Database::CommentOrm.where(video_id: video_id)
        db_records.map do |db_record|
          rebuild_entity(db_record)
        end
      end

      def self.create_many(entities)
        entities.map do |entity|
          create(entity)
        end
      end

      # Create a db_record from entity
      def self.create(entity)
        # raise 'Comment already exists' if find(entity)

        Database::CommentOrm.unrestrict_primary_key
        db_project = Database::CommentOrm.find_or_create(entity.to_hash)
        rebuild_entity(db_project)
      end

      # Get an entity from db_record
      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Comment.new(
          id: db_record.id,
          video_id: db_record.video_id,
          author: db_record.author,
          textDisplay: db_record.textDisplay,
          likeCount: db_record.likeCount,
          totalReplyCount: db_record.totalReplyCount
        )
      end
    end
  end
end
