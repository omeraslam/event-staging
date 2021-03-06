var EditorAsideNavItem = React.createClass({
    getInitialState: function() {
        return({currentItem: null})
    },
    selectItem: function(e) {

        this.props.handleSelectEvent(this.props.item)
    },
    componentWillReceiveProps: function(nextProps) {
        this.setState({currentItem: nextProps.currentItem})
    },
    render: function() {
            return (

                <li onClick={this.selectItem} className={(this.state.currentItem != null && this.state.currentItem.id == this.props.item.id) ? "active" : ""} >
                    <div className="editor-aside-nav-desc">
                        <h3>{this.props.item.title == undefined ? (this.props.item.question_text == undefined ? this.props.item.promo_code : this.props.item.question_text) : this.props.item.title}</h3>


                        <p>{this.props.item.description}</p>
                    </div>
                </li>
            );
    }
});