var EditorAsideNavItem = React.createClass({
    selectItem: function(e) {
        this.props.handleSelectEvent(this.props.item)
        //return this.props.item
    },
    render: function() {
            return (
                <li onClick={this.selectItem} >
                    <div className="editor-aside-nav-desc">
                        <h3>{this.props.item.title}</h3>
                        <p>{this.props.item.description}</p>
                    </div>
                </li>
            );
    }
});