module RailsDkNfHybrid
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def additional_foreign_key(association_id, options)
      raise "wrong association_id: #{association_id}" unless reflections[association_id] 
      raise "association macro, :#{reflections[association_id].macro}, is not supported." unless reflections[association_id].macro == :belongs_to
      before_save RailsDkNfHybrid::BelongsToCallback.new(association_id, options)
    end
  end

  class BelongsToCallback
    def initialize(association_id, options)
      @association_id = association_id
      raise ":foreign_key option not found" unless options[:foreign_key]
      @foreign_key = [options[:foreign_key]].flatten
      @referenced_foreign_key = (options[:referenced_foreign_key] && [options[:referenced_foreign_key]].flatten) || @foreign_key
      raise "length mismatch between the :foreign_key option and the :referenced_foreign_key option" unless @foreign_key.size == @referenced_foreign_key.size
    end

    def before_save(model)
      association = model.__send__(@association_id)
      [@foreign_key, @referenced_foreign_key].transpose.each do |fkey, skey| 
        model.__send__("#{fkey}=".to_sym, association.__send__(skey))
      end if association
    end
  end
end
