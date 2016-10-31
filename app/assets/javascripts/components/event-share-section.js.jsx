var EventShareSection = React.createClass({
    render: function() {
        return (
            <section>
                <h4>Share </h4>
                <a href={'https://www.facebook.com/sharer/sharer.php?u=http://www.eventcreate.com/'+ this.props.slug} className="btn btn-primary" target="_blank" id="facebook">Share on Facebook </a>
                <a href={"https://twitter.com/share?url=http://www.eventcreate.com/" + this.props.slug + '&amp;text=RSVP to "' + this.props.name + '" now!' } className="btn btn-primary" target="_blank" id="twitter">Share on Twitter </a>
            </section>
        )
    }
})

