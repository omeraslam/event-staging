var EditorAsideSectionNavItem = React.createClass({
    render: function() {
        return (
            <li><i className={this.props.item.icon}> </i> <div className="editor-aside-nav-desc"><h3>{this.props.item.title}</h3><p>{this.props.item.subheader}</p></div></li>
     )
    }
})