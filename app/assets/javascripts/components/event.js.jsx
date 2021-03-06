var Event = React.createClass({
    handleDelete: function(e) {
        $.ajax({
            method: 'DELETE',
            url: '/events/' + this.props.event.id,
            dataType: 'JSON',
            success: function() {
                this.props.handleDeleteEvent(this.props.event)
            }.bind(this)
        });
    },
    handleShow: function(e) {

    },
    _buildBackgroundImage: function() {
        return  this.props.event.background_img
    },
    _buildLinkHref: function(e) {
        return '/'+ this.props.event.slug + '?editing=true';
    },
    render: function() {
            return (
                <div className="event ">
                    <div className="image" style={{backgroundImage: 'url('+ this.props.event.background_img +')'}}> </div>
                    <div className="details">
                        <a href={this._buildLinkHref()} className="title" >{this.props.event.name}</a>
                        <div className="time">
                            {this.props.event.date_start}
                        </div>
                        <div className="actions">
                            <a href="" onClick={this.handleDelete} >Delete event</a>
                        </div>
                    </div>
                </div>
            );
    }
});