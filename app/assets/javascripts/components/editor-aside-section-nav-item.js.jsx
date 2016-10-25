var EditorAsideSectionNavItem = React.createClass({
    onClickSectionItem: function() {
            this.props.handleSelectSectionItem(this.props.item)
    },
    render: function() {
        return (
            <li onClick={this.onClickSectionItem}><i className={this.props.item.icon}> </i> <div className="editor-aside-nav-desc"><h3>{this.props.item.title}</h3><p>{this.props.item.subheader}</p></div></li>
     )
    }
})