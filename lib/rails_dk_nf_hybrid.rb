module RailsDkNfHybrid
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def additional_foreign_key(association_id, options)
      @additional_foreign_keys ||= []
      raise "wrong association_id: #{association_id}" unless reflections[association_id] 
      unless reflections[association_id].macro == :belongs_to
        raise "association macro, :#{reflections[association_id].macro}, is not supported."
      end
      raise ":foreign_key option not found" unless options[:foreign_key]
      foreign_key = [options[:foreign_key]].flatten
      referenced_foreign_key = options[:referenced_foreign_key] || foreign_key
      referenced_foreign_key = [referenced_foreign_key].flatten
      unless foreign_key.size == referenced_foreign_key.size
        raise "length mismatch between the :foreign_key option and the :referenced_foreign_key option"
      end
      @additional_foreign_keys << {
        :association_id => association_id,
        :foreign_key => foreign_key,
        :referenced_foreign_key => referenced_foreign_key
      }
      before_save RailsDkNfHybrid::BelongsToCallback.new(@additional_foreign_keys)
    end
  end

  class BelongsToCallback
    def initialize(additional_foreign_keys)
      @additional_foreign_keys = additional_foreign_keys
    end

    def before_save(model)
      @additional_foreign_keys.each do |options|
        assign_natural_key(model, options)
      end
    end

    private

    def assign_natural_key(model, options)
      association = model.__send__(options[:association_id])
      options.values_at(:foreign_key, :referenced_foreign_key).transpose.each do |fkey, skey| 
        model.__send__("#{fkey}=".to_sym, association.__send__(skey))
      end if association
    end
  end
end
