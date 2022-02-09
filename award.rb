Award = Struct.new(:name, :expires_in, :quality) do
    def self.new(name, expires_in, quality)
        Object.const_get(name.delete(' ')).new(expires_in, quality)
    end
end

class NORMALITEM
    attr_accessor :expires_in, :quality

    def initialize(expires_in, quality)
        @expires_in = expires_in
        @quality = quality
    end

    def appraise
        if @expires_in > 0
            @quality = [[@quality - 1, 0].max, 50].min
        else
            @quality = [[@quality - 2, 0].max, 50].min
        end
    end

    def mature
        @expires_in -= 1
    end
end

class BlueFirst < NORMALITEM
    # "Blue First" awards actually increase in quality the older they get
    def appraise
        if @expires_in > 0
            @quality = [[@quality + 1, 0].max, 50].min
        else
            @quality = [[@quality + 2, 0].max, 50].min
        end
    end
end

class BlueDistinctionPlus < NORMALITEM
    # "Blue Distinction Plus", being a highly sought distinction, never decreases in quality
    def appraise; @quality = 80 end

    def mature; nil end

end

class BlueCompare < NORMALITEM
    # "Blue Compare", similar to "Blue First", increases in quality as the expiration date approaches; 
    #  Quality increases by 2 when there are 10 days or less left, and by 3 where there are 5 days or less left, 
    #  but quality value drops to 0 after the expiration date.
    def appraise
        if @quality >= 50
            @quality = 50
        elsif @expires_in <= 0
            @quality = 0
        elsif @expires_in <= 10 && @expires_in >= 6
            @quality += 2
        elsif @expires_in <= 5
            @quality += 3
        else
            @quality += 1
        end
    end
end

class BlueStar < NORMALITEM
    # "Blue Star" awards should lose quality value twice as fast as normal awards.
    def appraise
        if @expires_in > 0
            @quality = [[@quality - 2, 0].max, 50].min
        else
            @quality = [[@quality - 4, 0].max, 50].min
        end
    end
end
