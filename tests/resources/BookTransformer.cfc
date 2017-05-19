component {

    function transform( book ) {
        return {
            "id" = book.getId(),
            "title" = book.getTitle(),
            "year" = book.getYear()
        };
    }

}