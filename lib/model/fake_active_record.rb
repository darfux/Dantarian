module FakeActiveRecord
  module ForForm
    module ClassMethods
      def has_fake_attr(*args)
        args.each do |atr|
          define_method atr do
            nil
          end
        end
      end
    end
    
    module InstanceMethods
      def model_name
        ActiveModel::Name.new(self.class)
      end
      def to_key
        nil
      end
      # Avoid polymorphic_path using model_name.singular_route_key
      # https://github.com/rails/rails/blob/e2ae787b36e32627974a0d448694c0067327fed7/actionpack/lib/action_dispatch/routing/polymorphic_routes.rb#LC293
      def persisted?
        false
      end
      def to_model
        self
      end
    end
    
    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end


