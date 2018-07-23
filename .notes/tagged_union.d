module tagged_union;

template TaggedUnion(Types ...) {
    private auto getUnionContent() {
        string s;
        foreach(T; Types) {
            s ~=  fullyQualifiedName!T ~ " member_" ~ T.mangleof ~ ";";
        }

        return s;
    }

    private auto getTag() {
        string s;
        foreach(T; Types) {
            s ~= T.mangleof ~ ",";
        }

        return "enum Tag {" ~ s ~ "}";
    }

    private auto getSwitchContent() {
        string s;
        foreach(T; Types) {
            s ~= "case Tag." ~ T.mangleof;
            s ~= ": return fun(member_" ~ T.mangleof ~ ");";
        }

        return s;
    }

    struct TaggedUnion {
    private:
        union {
            mixin(getUnionContent());
        }

        mixin(getTag());

        Tag tag;

    public:
        this(T)(T t) if(is(typeof(mixin("Tag." ~ T.mangleof)))) {
            mixin("tag = Tag." ~ T.mangleof ~ ";");
            mixin("member_" ~ T.mangleof ~ " = t;");
        }

        auto ref apply(alias fun)() {
            final switch(tag) {
                mixin(getSwitchContent());
            }
        }
    }
};
